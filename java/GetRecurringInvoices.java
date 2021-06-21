import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.Calendar;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class GetRecurringInvoices
 */
@WebServlet("/GetRecurringInvoices")
public class GetRecurringInvoices extends HttpServlet implements Runnable {
	private static final long serialVersionUID = 1L;
	Thread invoiceGenerator;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GetRecurringInvoices() {
        super();
    }
    
    @Override
    public void init() throws ServletException {
    	super.init();
    	invoiceGenerator = new Thread(this);
    	invoiceGenerator.setPriority(Thread.MIN_PRIORITY);
    	invoiceGenerator.start();
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		response.setContentType("text/html");
		PrintWriter out = response.getWriter();
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/accounting", "root", "");
			PreparedStatement stmt = con.prepareStatement("SELECT * FROM recurring_invoices");
			ResultSet rs = stmt.executeQuery();
			int count = 0;
			
			while (rs.next()) {
				out.println("<tr>");
				out.println("<td>" + rs.getString(2) + "</td>");
				out.println("<td><a href=\"recurring_invoice.jsp?id=" + rs.getString(1) + "\">" + rs.getString(3) + "</a></td>");
				String f = rs.getString(4);
				if (f.equals("D")) {
					f = "Daily";
				}
				else if (f.equals("M")) {
					f = "Monthly";
				}
				else if (f.equals("W")) {
					f = "Weekly";
				}
				else {
					f = "Yearly";
				}
				out.println("<td>" + f + "</td>");
				out.println("<td>" + rs.getString(5) + "</td>");
				out.println("<td>" + rs.getString(6) + "</td>");
				String s = rs.getString(8);
				if (s.equals("A")) {
					s = "Active";
				}
				else if (s.equals("E")) {
					s = "Expired";
				}
				else {
					s = "Stopped";
				}
				out.println("<td>" + s + "</td>");
				out.println("<td>" + rs.getString(11) + "</td>");
				out.println("</tr>");
				count++;
			}
			
			if (count == 0) {
				out.println("<tr><td class=\"text-center\" colspan=\"7\">");
				out.println("No Recorring Invoices created yet!</td></tr>");
			}
			
			rs.close();
			stmt.close();
			con.close();
		}
		catch(Exception e) {
			out.println("<tr><td class=\"text-center\" colspan=\"7\">");
			out.println(e + "</td></tr>");
		}
		
		out.close();
	}

	@Override
	public void run() {
		java.util.Date cur;
		Calendar c = Calendar.getInstance();
		while (true) {
			try {
				Class.forName("com.mysql.jdbc.Driver");
				Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/accounting", "root", "");
				PreparedStatement stmt = con.prepareStatement("SELECT * FROM recurring_invoices");
				ResultSet rs = stmt.executeQuery();
				SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
				cur = new java.util.Date();
				
				while (rs.next()) {
					java.util.Date nextDate = df.parse(rs.getString(6));
					if (cur.equals(nextDate) || cur.after(nextDate)) {
						String status = rs.getString(8);
						if (status.equals("E") || status.equals("S"))
							continue;
						int recurId = rs.getInt(1);
						String cust = rs.getString(2);
						int itemId = rs.getInt(9);
						int quantity = rs.getInt(10);
						double amount = rs.getDouble(11);
						String date = rs.getString(6);
						String freq = rs.getString(4);
						
						PreparedStatement ps1 = con.prepareStatement("INSERT INTO invoices(customer, item_id, quantity, amount, date, recur_id) VALUES (?, ?, ?, ?, ?, ?)");
						ps1.setString(1, cust);
						ps1.setInt(2, itemId);
						ps1.setInt(3, quantity);
						ps1.setDouble(4, amount);
						ps1.setString(5, date);
						ps1.setInt(6, recurId);
						ps1.executeUpdate();
						ps1.close();
						
						PreparedStatement ps2 = con.prepareStatement("UPDATE recurring_invoices SET last_date = ?, next_date = ?, status = ? WHERE id = " + recurId);
						ps2.setString(1, date);
						c.setTime(nextDate);
						String next;
						if (freq.equals("W")) {
							c.add(Calendar.DATE, 7);
							next = df.format(c.getTime());
						}
						else if (freq.equals("M")) {
							c.add(Calendar.MONTH, 1);
							next = df.format(c.getTime());
						}
						else if (freq.equals("Y")) {
							c.add(Calendar.YEAR, 1);
							next = df.format(c.getTime());
						}
						else {
							c.add(Calendar.DATE, 1);
							next = df.format(c.getTime());
						}
						ps2.setString(2, next);
						String e = rs.getString(7);
						if (e != null && !e.equals("")) {
							java.util.Date end = df.parse(e);
							if (cur.after(end) || cur.equals(end))
								ps2.setString(3, "E");
							else
								ps2.setString(3, "A");
						}
						else {
							ps2.setString(3, "A");
						}
						ps2.executeUpdate();
						ps2.close();
					}
				}
				rs.close();
				con.close();
				
				Thread.sleep(3600000);
			}
			catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
	
	@SuppressWarnings("deprecation")
	@Override
	public void destroy() {
		super.destroy();
		invoiceGenerator.stop();
	}

}
