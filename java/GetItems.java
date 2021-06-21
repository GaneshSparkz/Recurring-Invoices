import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class GetItems
 */
@WebServlet("/GetItems")
public class GetItems extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GetItems() {
        super();
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
			PreparedStatement stmt = con.prepareStatement("SELECT * FROM items");
			ResultSet rs = stmt.executeQuery();
			int count = 0;
			
			while (rs.next()) {
				out.println("<tr>");
				out.println("<td>" + rs.getString(2) + "</td>");
				out.println("<td>" + rs.getString(3) + "</td>");
				out.println("<td>" + rs.getString(4) + "</td>");
				out.println("</tr>");
				count++;
			}
			
			if (count == 0) {
				out.println("<tr><td class=\"text-center\" colspan=\"7\">");
				out.println("No Items added yet!</td></tr>");
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

}
