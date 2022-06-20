<%@ Page Language="C#" %>
<!DOCTYPE html>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        
    }
</script>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        SET IDENTITY_INSERT PartCategory ON<br />GO<br />
        <asp:Repeater ID="Repeater1" runat="server" DataSourceID="SqlDataSourceCats">
            <ItemTemplate>
                INSERT INTO PartCategory (PCpkey, ParentID,PCName, PCDescription) VALUES (<%#Eval("PCpkey") %>, <%#Eval("ParentID") %>, '<%#Eval("PCName").ToString().Replace("'","") %>' , '<%#Eval("PCDescription").ToString().Replace("'","") %>')<br />
GO
                <br />
            </ItemTemplate>
        </asp:Repeater>
         SET IDENTITY_INSERT PartCategory OFF<br />GO<br />

        SET IDENTITY_INSERT FootprintCategory ON<br />GO<br />
        <asp:Repeater ID="Repeater2" runat="server" DataSourceID="SqlDataSourceFootprintCategory">
            <ItemTemplate>
                INSERT INTO FootprintCategory (FCPkey, FCName,FCDescription, ParentCategory) VALUES (<%#Eval("FCPkey") %>, '<%#Eval("FCName").ToString().Replace("'","") %>', '<%#Eval("FCDescription").ToString().Replace("'","") %>' , <%#Eval("ParentCategory") %>)<br />
GO
                <br />
            </ItemTemplate>
        </asp:Repeater>
         SET IDENTITY_INSERT FootprintCategory OFF<br />GO<br />

        SET IDENTITY_INSERT Footprint ON<br />GO<br />
        <asp:Repeater ID="Repeater3" runat="server" DataSourceID="SqlDataSourceFootprint">
            <ItemTemplate>
                INSERT INTO Footprint (FootprintPkey, FootprintName,FootprintDescription, FootprintImage, FootprintCategory) VALUES (<%#Eval("FootprintPkey") %>, '<%#Eval("FootprintName").ToString().Replace("'","") %>', '<%#Eval("FootprintDescription").ToString().Replace("'","") %>' , '<%#Eval("FootprintImage").ToString().Replace("'","") %>', <%#Eval("FootprintCategory") %>)<br />
GO
                <br />
            </ItemTemplate>
        </asp:Repeater>
         SET IDENTITY_INSERT Footprint OFF<br />GO<br />
        <asp:SqlDataSource ID="SqlDataSourceCats" runat="server" ConnectionString="<%$ ConnectionStrings:MainConn %>" SelectCommand="SELECT * FROM [PartCategory] ORDER BY [PCName]"></asp:SqlDataSource>
        <asp:SqlDataSource ID="SqlDataSourceFootprintCategory" runat="server" ConnectionString="<%$ ConnectionStrings:MainConn %>" SelectCommand="SELECT * FROM [FootprintCategory] ORDER BY [FCName]"></asp:SqlDataSource>
        <asp:SqlDataSource ID="SqlDataSourceFootprint" runat="server" ConnectionString="<%$ ConnectionStrings:MainConn %>" SelectCommand="SELECT * FROM [Footprint] ORDER BY [FootprintName]"></asp:SqlDataSource>
        
    </form>
</body>
</html>
