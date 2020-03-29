<%@ Page Language="C#" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<script runat="server">

    // optional page to process moving categories via the fancytree tree menu system.
    protected void Page_Load(object sender, EventArgs e)
    {

        if (Request.Form["source"] != null && Request.Form["target"] != null)
        {

            int source = 0;
            int target = 0;
            if (Int32.TryParse(Request.Form["source"].ToString(), out source) && Int32.TryParse(Request.Form["target"].ToString(), out target))
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MainConn"].ConnectionString.ToString()))
                {
                    conn.Open();
                    using (SqlCommand cmd = new SqlCommand("UPDATE PartCategory SET ParentID = @ParentID WHERE PCpkey = @PCpkey", conn))
                    {
                        cmd.Parameters.AddWithValue("@ParentID", target);
                        cmd.Parameters.AddWithValue("@PCpkey", source);
                        cmd.ExecuteNonQuery();
                    }
                }
                Response.Write("saved");
            }

        }
    }
</script>