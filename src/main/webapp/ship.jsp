<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.*" %>
<jsp:include page="header.jsp"/>
<%@ page import="com.mackenzie.lab7.Connections" %>

<html>
<head>
<title>YOUR NAME Grocery Shipment Processing</title>
</head>
<body>

<%
	String orderId = request.getParameter("orderId");
	List<ShippedItem> items = shipItems(orderId);
	boolean ShipSuccess = true;
	if(items.isEmpty()){
		ShipSuccess = false;
%>
<p><strong>Invalid order id</strong></p>
<%
	}
	if(items.size() > 3){
		ShipSuccess = false;
%>
<p><strong>Too many items in order</strong></p>
<%
	}

	for(ShippedItem item : items){
		if(item.success){
%>
<p>Order product: <%=item.productId%> Qty: <%=item.quantity%> Previous Inventory: <%=item.inventory%> New Inventory: <%=item.newInventory%></p>
<%
	}else{
		ShipSuccess = false;
%>
<p><strong><%=item.errMessage%></strong></p>
<%
	}}
%>


<%
	if(ShipSuccess){
%>
		<p><strong>Shipment successfully processed</strong></p>
<%
	}
%>


<button class="btn btn-secondary"><a class="text-decoration-none text-white" href="index.jsp">Back to Main Page</a></button>

</body>
</html>

<%!
	public class ShippedItem{
		public String productId;
		public int quantity;
		public int inventory;
		public int newInventory;
		public boolean success;
		public String errMessage;
	}

	private List<ShippedItem> shipItems(String orderId){
		List<ShippedItem> items = new ArrayList<>();
		Connections con = new Connections();
		try{
			con.getConnection();

			PreparedStatement pstmt = con.con.prepareStatement("SELECT * FROM orderproduct where orderId = ?");
			pstmt.setString(1, orderId);
			ResultSet rs = pstmt.executeQuery();

			con.con.setAutoCommit(false);

			PreparedStatement newShipQuery = con.con.prepareStatement("INSERT INTO shipment (warehouseId, shipmentDate) VALUES (1,?)");
			newShipQuery.setDate(1, new java.sql.Date(new java.util.Date().getTime()));
			newShipQuery.executeUpdate();

			int count = 0;
			while(rs.next()) {
				count++;
				ShippedItem item = new ShippedItem(){{
					productId = rs.getString("productId");
					quantity = rs.getInt("quantity");
				}};
				PreparedStatement prodInventoryQuery = con.con.prepareStatement("SELECT * FROM productinventory where productId = ? and warehouseId = 1");
				prodInventoryQuery.setString(1, item.productId);
				ResultSet prodInventory = prodInventoryQuery.executeQuery();

				if(!prodInventory.next()){
					item.success = false;
					item.errMessage = "Shipment not done. Insufficient inventory for product id: " + item.productId;
					items.add(item);
					con.con.rollback();
					break;
				}

				item.inventory = prodInventory.getInt("quantity");

				if(item.inventory < item.quantity){
					item.success = false;
					item.errMessage = "Shipment not done. Insufficient inventory for product id: " + item.productId;
					items.add(item);
					con.con.rollback();
					break;
				}
				item.newInventory = item.inventory - item.quantity;
				PreparedStatement updateInventoryQuery = con.con.prepareStatement("UPDATE productinventory SET quantity = ? WHERE productId = ? and warehouseId = 1");
				updateInventoryQuery.setInt(1, item.newInventory);
				updateInventoryQuery.setString(2, item.productId);
				updateInventoryQuery.executeUpdate();

				item.success = true;
				items.add(item);
			}


			if(items.isEmpty() || count > 3){
				con.con.rollback();
				return items;
			}

			con.con.commit();
			con.con.setAutoCommit(true);

		}catch (SQLException e){
			System.err.print(e);
		}
		finally {
			con.closeConnection();
		}

		return items;
	}
%>