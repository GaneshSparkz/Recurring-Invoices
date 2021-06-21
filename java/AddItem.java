import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class AddItem
 */
@WebServlet("/AddItem")
public class AddItem extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AddItem() {
        super();
    }

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String name = request.getParameter("name");
		int rate = Integer.parseInt(request.getParameter("rate"));
		int tax = Integer.parseInt(request.getParameter("tax"));
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/accounting", "root", "");
			PreparedStatement stmt = con.prepareStatement("INSERT INTO items (name, rate, tax) VALUES (?, ?, ?)");
			stmt.setString(1, name);
			stmt.setInt(2, rate);
			stmt.setInt(3, tax);
			stmt.executeUpdate();
			stmt.close();
			con.close();
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		
		response.sendRedirect("items.jsp");
	}

}
