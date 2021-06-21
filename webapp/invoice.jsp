<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<jsp:include page="header.jsp">
	<jsp:param value="2" name="a"/>
</jsp:include>

<%
int id = Integer.parseInt(request.getParameter("id"));
try {
	Class.forName("com.mysql.jdbc.Driver");
	Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/accounting", "root", "");
	PreparedStatement stmt = con.prepareStatement("SELECT * FROM invoices WHERE id = " + id);
	ResultSet rs = stmt.executeQuery();
	if (rs.next()) {
%>

<div class="row justify-content-center my-4">
<div style="border: 1px solid black;" class="col-7 p-3">
	<h1>Invoice</h1>
	<div class="my-3">Invoice# <%= rs.getTimestamp(2).getTime() %></div>
	<div class="my-3">Invoice Date: <%= rs.getString(7) %></div>
	<h5>Amount: ₹ <%= rs.getString(6) %></h5>
	<div class="mt-5">Bill To</div>
	<div class="mb-5"><b><%= rs.getString(3) %></b></div>
	<table class="table mt-5">
		<thead class="table-dark">
			<tr>
				<th>Item</th>
				<th>Quantity</th>
				<th>Rate</th>
				<th>Tax %</th>
				<th>Amount</th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td id="item"></td>
				<td id="quantity"><%= rs.getString(5) %></td>
				<td id="rate"></td>
				<td id="tax"></td>
				<td id="amount"></td>
			</tr>
		</tbody>
	</table>
	<div class="text-end">
		<div class="mb-3">Sub Total<span class="mx-5"></span>₹<span id="sub"></span>.00</div>
		<div class="mb-3">Tax <span id="totalTax"></span>.00</div>
		<h4 class="mb-5">Total <span class="mx-4"></span>₹<span id="total"></span>.00</h4>
	</div>
	<div class="mt-5">
		<p><b>Notes</b></p>
		<small>Thanks for your Business!</small>
	</div>
</div>
</div>

<script>
	$(function () {
		$.ajax({
			url: "GetItem?id=" + <%= rs.getString(4) %>,
			type: "GET",
			success: function (res) {
				$("#item").html(res[4]);
				$("#rate").html(res[0]);
				$("#tax").html(res[1]);
				var rate = parseFloat(res[0]);
				var tax = parseFloat(res[1]);
				var qty = parseInt(document.getElementById("quantity").innerHTML);
				$("#amount").html(rate * qty);
				$("#sub").html(rate * qty);
				$("#totalTax").html((res[1]) + "%<span class=\"mx-5\"></span>₹" + (rate * qty) * tax / 100.0);
				$("#total").html((rate * qty) + ((rate * qty) * tax / 100.0))
			},
			error: function (err) {
				console.log(err);
			}
		});
	});
</script>

<%
	}
	rs.close();
	stmt.close();
	con.close();
}
catch (Exception e) {
	out.println(e);
}
%>

<%@ include file="footer.jsp" %>
