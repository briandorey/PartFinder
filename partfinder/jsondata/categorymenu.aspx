<%@ Page Language="C#" %>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        CategoryHelpers nav = new CategoryHelpers();
        Response.Write(nav.MakeCategoryMenu());
    }
</script>
