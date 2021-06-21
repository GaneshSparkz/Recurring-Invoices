<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<jsp:include page="header.jsp">
	<jsp:param value="1" name="a"/>
</jsp:include>

<%
try {
	Class.forName("com.mysql.jdbc.Driver");
	Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/accounting", "root", "");
	PreparedStatement stmt = con.prepareStatement("SELECT id, name FROM items");
	ResultSet rs = stmt.executeQuery();
%>

<div class="container my-4">
<h1>New Recurring Invoice</h1>
<form class="form-group" method="POST" action="AddRecurringInvoice">
	<label for="customer">Customer Name</label>
	<input class="form-control mb-3" type="text" id="customer" name="customer" required>
	
	<label for="name">Profile Name</label>
	<input class="form-control mb-3" type="text" id="name" name="name" required>
	
	<label for="frequency">Repeat Every</label>
	<select class="form-control mb-3" id="frequency" name="frequency" required>
		<option value="D">Day</option>
		<option value="W">Week</option>
		<option value="M">Month</option>
		<option value="Y">Year</option>
	</select>
	
	<label for="start">Starts on</label>
	<input class="form-control mb-3" type="date" id="start" name="start" required>
	
	<div class="form-check mb-3">
	  	<input class="form-check-input" type="checkbox" id="never" checked>
	  	<label class="form-check-label" for="never">Never Expires</label>
	</div>
	
	<label for="end">Ends on</label>
	<input class="form-control mb-3" type="date" id="end" name="end" disabled>
	
	<div class="row mb-3">
		<div class="col-3">
			<label for="item">Item</label>
			<select class="form-control" id="item" name="item" required>
				<option value="">Choose...</option>
			<% while (rs.next()) { %>
				<option value="<%= rs.getString(1) %>"><%= rs.getString(2) %></option>
			<% } %>
			</select>
		</div>
		
		<div class="col-2">
			<label for="quantity">Quantity</label>
			<input class="form-control" type="number" id="quantity" name="quantity" value="1" required>
		</div>
		
		<div class="col-2">
			<label for="rate">Rate</label>
			<div class="input-group">
			<span class="input-group-text">₹</span>
			<input class="form-control" type="text" id="rate" name="rate" disabled readonly>
			<span class="input-group-text">.00</span>
			</div>
		</div>
		
		<div class="col-2">
			<label for="tax">Tax %</label>
			<div class="input-group">
			<input class="form-control" type="text" id="tax" name="tax" disabled readonly>
			<span class="input-group-text">%</span>
			</div>
		</div>
		
		<div class="col-3">
			<label for="amount">Amount</label>
			<div class="input-group">
			<span class="input-group-text">₹</span>
			<input class="form-control" type="text" id="amount" name="amount" disabled readonly>
			<span class="input-group-text">.00</span>
			</div>
		</div>
		
		<input type="hidden" id="totAmt" name="totAmt">
	</div>
	
	<div class="text-end">
		<div class="mb-3">Sub Total <span class="mx-5"></span>₹<span id="sub"></span>.00</div>
		<div class="mb-3">Tax <span id="totalTax"></span>.00</div>
		<h4 class="mb-4">Total <span class="mx-4"></span>₹<span id="total"></span>.00</h4>
	</div>
	
	<button class="btn btn-success" type="submit"><i class="bi bi-check-lg"></i> Save</button>
</form>
</div>

<%
	rs.close();
	stmt.close();
	con.close();
}
catch(Exception e) {
	out.println(e);
}
%>

<script type="text/javascript">
	$(function () {
		$("#never").click(function () {
			if (this.checked) {
				$("#end").attr('disabled', 'disabled');
			}
			else {
				$("#end").removeAttr('disabled');
			}
		});
		
		$("#item").change(function () {
			var itemId = $("#item").val();
			if (itemId == "")
				return;
			$.ajax({
				url: "GetItem?id=" + itemId,
				type: 'GET',
				success: function (res) {
					$("#rate").val(parseInt(res[0]));
					$("#tax").val(parseInt(res[1]));
					$("#amount").val(parseInt(res[0]));
					$("#sub").html(parseInt(res[0]));
					$("#totalTax").html(res[1] + "%<span class=\"mx-5\"></span>₹" + parseInt(res[2]));
					$("#total").html(parseInt(res[3]));
					$("#totAmt").val(parseInt(res[3]));
				},
				error: function(err) {
					console.log(err);
				}
			});
		});
		
		$("#quantity").change(function () {
			var rate = parseFloat(document.getElementById("rate").value);
			var qty = parseInt(document.getElementById("quantity").value);
			var tax = parseInt(document.getElementById("tax").value);
			$("#amount").val(rate * qty);
			$("#sub").html(rate * qty);
			$("#totalTax").html(tax + "%<span class=\"mx-5\"></span>₹" + ((rate * qty) * tax / 100.0));
			$("#total").html((rate * qty) + ((rate * qty) * tax / 100.0));
			$("#totAmt").val((rate * qty) + ((rate * qty) * tax / 100.0));
		});
	});
</script>

<%@ include file="footer.jsp" %>
