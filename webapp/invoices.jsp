<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<jsp:include page="header.jsp">
	<jsp:param value="2" name="a"/>
</jsp:include>

<div class="container my-4">
	<h1>Invoices</h1>
	<a href="new_invoice.jsp" class="btn btn-success my-3"><i class="bi bi-plus-lg"></i> New</a>
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
</div>

<script type="text/javascript">
	document.getElementById("content").innerHTML = "<tr><td class=\"text-center\" colspan=\"4\"><div class=\"spinner-border text-primary\" role=\"status\"><span class=\"visually-hidden\">Loading...</span></div></td></tr>";
	var xmlHttp = new XMLHttpRequest();
	xmlHttp.onreadystatechange = function() {
		if (xmlHttp.readyState == 4 && xmlHttp.status == 200) {
			document.getElementById("content").innerHTML = xmlHttp.responseText;
		}
	}
	xmlHttp.open('GET', "GetInvoices");
	xmlHttp.send();
</script>

<%@ include file="footer.jsp" %>
