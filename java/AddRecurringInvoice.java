import java.io.IOException;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.Calendar;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class AddRecurringInvoice
 */
@WebServlet("/AddRecurringInvoice")
public class AddRecurringInvoice extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AddRecurringInvoice() {
        super();
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String cust = request.getParameter("customer");
		String name = request.getParameter("name");
		String freq = request.getParameter("frequency");
		String start = request.getParameter("start");
		String end = request.getParameter("end");
		int itemId = Integer.parseInt(request.getParameter("item"));
		int quantity = Integer.parseInt(request.getParameter("quantity"));
		double amount = Double.parseDouble(request.getParameter("totAmt"));
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/accounting", "root", "");
			PreparedStatement stmt = con.prepareStatement("INSERT INTO recurring_invoices(customer, name, frequency, last_date, next_date, end_date, item_id, quantity, amount) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)", Statement.RETURN_GENERATED_KEYS);
			
			java.util.Date s = df.parse(start);
			String next;
			Calendar c = Calendar.getInstance();
			c.setTime(s);
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
			
			stmt.setString(1, cust);
			stmt.setString(2, name);
			stmt.setString(3, freq);
			stmt.setString(4, start);
			stmt.setString(5, next);
			if (end == null || end.equals("")) {
				stmt.setNull(6, Types.DATE);
			}
			else {
				stmt.setString(6, end);
			}
			stmt.setInt(7, itemId);
			stmt.setInt(8, quantity);
			stmt.setDouble(9, amount);
			stmt.executeUpdate();
			ResultSet rs = stmt.getGeneratedKeys();
			int recurId = 0;
			if (rs.next()) {
				recurId = rs.getInt(1);
			}
			
			stmt.close();
			PreparedStatement ps = con.prepareStatement("INSERT INTO invoices(customer, item_id, quantity, amount, date, recur_id) VALUES (?, ?, ?, ?, ?, ?)");
			ps.setString(1, cust);
			ps.setInt(2, itemId);
			ps.setInt(3, quantity);
			ps.setDouble(4, amount);
			ps.setString(5, start);
			ps.setInt(6, recurId);
			ps.executeUpdate();
			ps.close();
			con.close();
		}
		catch (Exception e) {
			System.out.println(e);
		}
		
		response.sendRedirect("index.jsp");
	}

}
