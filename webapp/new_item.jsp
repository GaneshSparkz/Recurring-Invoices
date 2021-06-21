<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<jsp:include page="header.jsp">
	<jsp:param value="3" name="a"/>
</jsp:include>

<div class="container my-4">
<h1>New Item</h1>
<form class="form-group" method="POST" action="AddItem">
	<label for="name">Item Name</label>
	<input class="form-control mb-3" type="text" id="name" name="name" required>
	
	<label for="rate">Rate</label>
	<input class="form-control mb-3" type="number" id="rate" name="rate" required>
	
	<label for="tax">Tax</label>
	<select class="form-control mb-3" id="tax" name="tax">
		<option value="20">Standard Rate (20%)</option>
		<option value="5">Reduced Rate (5%)</option>
		<option value="0">Zero Rate (0%)</option>
	</select>
	
	<button class="btn btn-success" type="submit"><i class="bi bi-check-lg"></i> Save</button>
</form>
</div>

<%@ include file="footer.jsp" %>
