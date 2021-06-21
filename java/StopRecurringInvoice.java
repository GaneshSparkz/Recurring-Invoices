import java.io.IOException;
import java.sql.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class StopRecurringInvoice
 */
@WebServlet("/StopRecurringInvoice")
public class StopRecurringInvoice extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public StopRecurringInvoice() {
        super();
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int id = Integer.parseInt(request.getParameter("id"));
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/accounting", "root", "");
			PreparedStatement stmt = con.prepareStatement("UPDATE recurring_invoices SET status = \'S\' WHERE id = " + id);
			stmt.executeUpdate();
			stmt.close();
			con.close();
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		response.sendRedirect("recurring_invoice.jsp?id=" + id);
	}

}
