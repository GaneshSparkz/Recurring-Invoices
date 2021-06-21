<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<jsp:include page="header.jsp">
	<jsp:param value="1" name="a"/>
</jsp:include>

<%
int id = Integer.parseInt(request.getParameter("id"));
try {
	Class.forName("com.mysql.jdbc.Driver");
	Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/accounting", "root", "");
	PreparedStatement stmt = con.prepareStatement("SELECT * FROM recurring_invoices WHERE id = " + id);
	ResultSet rs = stmt.executeQuery();
	if (rs.next()) {
%>

<div class="container my-4">
	<h3>Recurring Invoice - <%= rs.getString(3) %></h3>
	<div class="row my-3">
		<div class="col-3"><b>Customer Name</b></div>
		<div class="col-4"><%= rs.getString(2) %></div>
	</div>
	<div class="row my-3">
		<div class="col-3"><b>Repeat Every</b></div>
		<div class="col-4">
			<%
			String freq = rs.getString(4);
			if (freq.equals("D")) out.println("Day");
			else if (freq.equals("W")) out.println("Week");
			else if (freq.equals("M")) out.println("Month");
			else out.println("Year");
			%>
		</div>
	</div>
	<div class="row my-3">
		<div class="col-3"><b>Last Invoice Date</b></div>
		<div class="col-4"><%= rs.getString(5) %></div>
	</div>
	<div class="row my-3">
		<div class="col-3"><b>Next Invoice Date</b></div>
		<div class="col-4"><%= rs.getString(6) %></div>
	</div>
	<div class="row my-3">
		<div class="col-3"><b>Status</b></div>
		<div class="col-4">
			<%
			String status = rs.getString(8);
			if (status.equals("A")) out.println("Active");
			else if (status.equals("E")) out.println("Expired");
			else out.println("Stopped");
			%>
		</div>
	</div>
	<div class="row my-3">
		<div class="col-3"><b>End Date</b></div>
		<div class="col-4">
			<%
			String end = rs.getString(7);
			if (end == null || end.equals("")) out.println("Never Expires");
			else out.println(end);
			%>
		</div>
	</div>

	<h4>Child Invoices</h4>
	<table class="table table-bordered">
	<thead>
		<tr>
			<th>Date</th>
			<th>Invoice No.</th>
			<th>Customer Name</th>
			<th>Amount</th>
		</tr>
	</thead>
	<tbody id="content"></tbody>
	</table>
	
	<div class="row my-4">
		<div class="col-2">
			<a class="btn btn-primary" href="index.jsp"><i class="bi bi-arrow-return-left"></i> Back</a>
		</div>
		<% if (status.equals("A")) { %>
		<div class="col-2">
			<button type="button" class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#confirmStop">
			  <i class="bi bi-stop-fill"></i> Stop
			</button>
		</div>
		<% } %>
	</div>
	
	<% if (status.equals("A")) { %>
	<!-- Modal -->
	<div class="modal fade" id="confirmStop" tabindex="-1" aria-labelledby="confirmStopLabel" aria-hidden="true">
	  <div class="modal-dialog">
	    <div class="modal-content">
	      <div class="modal-header">
	        <h5 class="modal-title" id="confirmStopLabel">Are you sure?</h5>
	        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
	      </div>
	      <div class="modal-body">
	        Do you want to stop this Recurring Invoice?
	      </div>
	      <div class="modal-footer">
	        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
	        <a href="StopRecurringInvoice?id=<%= id %>" class="btn btn-danger">Stop</a>
	      </div>
	    </div>
	  </div>
	</div>
	<% } %>
</div>

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

<script type="text/javascript">
	document.getElementById("content").innerHTML = "<tr><td class=\"text-center\" colspan=\"4\"><div class=\"spinner-border text-primary\" role=\"status\"><span class=\"visually-hidden\">Loading...</span></div></td></tr>";
	var xmlHttp = new XMLHttpRequest();
	xmlHttp.onreadystatechange = function() {
		if (xmlHttp.readyState == 4 && xmlHttp.status == 200) {
			document.getElementById("content").innerHTML = xmlHttp.responseText;
		}
	}
	xmlHttp.open('GET', "GetChildInvoices?recurId=" + <%= id %>);
	xmlHttp.send();
</script>

<%@ include file="footer.jsp" %>
