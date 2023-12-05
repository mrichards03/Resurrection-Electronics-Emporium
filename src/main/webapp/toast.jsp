<%
  String message = request.getParameter("message");
  boolean success = Boolean.parseBoolean(request.getParameter("success"));
%>
<!DOCTYPE html>
<html>
<head>
  <script>
    document.addEventListener('DOMContentLoaded', (event) => {
      var toastElList = [].slice.call(document.querySelectorAll('.toast'))
      var toastList = toastElList.map(function(toastEl) {
        return new bootstrap.Toast(toastEl)
      });
      toastList.forEach(toast => toast.show());
    });
  </script>
</head>
<body>
<div aria-live="polite" aria-atomic="true" style="position: relative;">
  <div id="toast-container" style="position: absolute; top: 0; right: 0;">
    <div class="toast align-items-center text-bg-<%=success ? "success":"danger"%> border-0" role="alert"
         aria-live="assertive" aria-atomic="true">
      <div class="d-flex align-items-center">
        <div class="toast-body">
          <%=message%>
        </div>
        <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
      </div>
    </div>
    </div>
</div>
</body>
</html>
