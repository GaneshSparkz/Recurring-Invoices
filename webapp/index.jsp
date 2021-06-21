<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<jsp:include page="header.jsp">
	<jsp:param value="1" name="a"/>
</jsp:include>

<div class="container my-4">
	<h1>Recurring Invoices</h1>
	<a href="new_recurring_invoice.jsp" class="btn btn-success my-3"><i class="bi bi-plus-lg"></i> New</a>
	<table class="table table-bordered">
	<thead>
		<tr>
			<th>Customer Name</th>
			<th>Profile Name</th>
			<th>Frequency</th>
			<th>Last Invoice Date</th>
			<th>Next Invoice Date</th>
			<th>Status</th>
			<th>Amount</th>
		</tr>
	</thead>
	<tbody id="content"></tbody>
	</table>
</div>

<script type="text/javascript">
	document.getElementById("content").innerHTML = "<tr><td class=\"text-center\" colspan=\"7\"><div class=\"spinner-border text-primary\" role=\"status\"><span class=\"visually-hidden\">Loading...</span></div></td></tr>";
	var xmlHttp = new XMLHttpRequest();
	xmlHttp.onreadystatechange = function() {
		if (xmlHttp.readyState == 4 && xmlHttp.status == 200) {
			document.getElementById("content").innerHTML = xmlHttp.responseText;
		}
	}
	xmlHttp.open('GET', "GetRecurringInvoices");
	xmlHttp.send();
</script>

<%@ include file="footer.jsp" %>
