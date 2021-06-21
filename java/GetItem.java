import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import java.sql.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.*;

/**
 * Servlet implementation class GetItem
 */
@WebServlet("/GetItem")
public class GetItem extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GetItem() {
        super();
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		List<String> res = new ArrayList<>();
		int id = Integer.parseInt(request.getParameter("id"));
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		
		try {
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/accounting", "root", "");
			PreparedStatement stmt = con.prepareStatement("SELECT name, rate, tax FROM items WHERE id = " + id);
			ResultSet rs = stmt.executeQuery();
			
			if (rs.next()) {
				Double rate = rs.getDouble(2);
				Double tax = rs.getDouble(3);
				Double totalTax = rate * tax / 100;
				Double total = rate + totalTax;
				String name = rs.getString(1);
				res.add(rate.toString());
				res.add(tax.toString());
				res.add(totalTax.toString());
				res.add(total.toString());
				res.add(name);
			}
			
			rs.close();
			stmt.close();
			con.close();
		}
		catch(Exception e) {
			System.out.println(e);
		}
		
		String json = new Gson().toJson(res);
		response.getWriter().write(json);
	}

}
