<%
int active = Integer.parseInt(request.getParameter("a"));
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<!-- CSS only -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-+0n0xVW2eSR5OomGNYDnhzAbDsOXxcvSN1TPprVMTNDbiYZCxYbOOl7+AMvyTG2x" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.5.0/font/bootstrap-icons.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js" integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4=" crossorigin="anonymous"></script>
<!-- JavaScript Bundle with Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-gtEjrD/SeCtmISkJkNUaaKMoLD0//ElJ19smozuHV6z3Iehds+3Ulb9Bn9Plx0x4" crossorigin="anonymous"></script>
<title>Recurring Invoices</title>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
  <div class="container">
    <a class="navbar-brand" href="index.jsp">Home</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNav">
      <ul class="navbar-nav">
        <li class="nav-item">
        <% if (active == 1) { %>
          <a class="nav-link active" href="index.jsp">Recurring Invoices</a>
        <%
        }
        else {
        %>
          <a class="nav-link" href="index.jsp">Recurring Invoices</a>
        <% } %>
        </li>
        <li class="nav-item">
        <% if (active == 2) { %>
          <a class="nav-link active" href="invoices.jsp">Invoices</a>
        <%
        }
        else {
        %>
          <a class="nav-link" href="invoices.jsp">Invoices</a>
        <% } %>
        </li>
        <li class="nav-item">
        <% if (active == 3) { %>
          <a class="nav-link active" href="items.jsp">Items</a>
        <%
        }
        else {
        %>
          <a class="nav-link" href="items.jsp">Items</a>
        <% } %>
        </li>
      </ul>
    </div>
  </div>
</nav>
