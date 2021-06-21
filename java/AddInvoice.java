import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class AddInvoice
 */
@WebServlet("/AddInvoice")
public class AddInvoice extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AddInvoice() {
        super();
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String cust = request.getParameter("customer");
		String date = request.getParameter("date");
		int itemId = Integer.parseInt(request.getParameter("item"));
		int quantity = Integer.parseInt(request.getParameter("quantity"));
		double amount = Double.parseDouble(request.getParameter("totAmt"));
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/accounting", "root", "");
			PreparedStatement stmt = con.prepareStatement("INSERT INTO invoices (customer, item_id, quantity, amount, date) VALUES (?, ?, ?, ?, ?)");
			stmt.setString(1, cust);
			stmt.setInt(2, itemId);
			stmt.setInt(3, quantity);
			stmt.setDouble(4, amount);
			stmt.setString(5, date);
			stmt.executeUpdate();
			stmt.close();
			con.close();
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		
		response.sendRedirect("invoices.jsp");
	}

}
