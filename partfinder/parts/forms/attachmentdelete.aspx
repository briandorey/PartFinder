<%@ Page Language="C#" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<script runat="server">
    string Filename = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        int pkey = Helpers.QueryStringReturnNumber("id");
        if (pkey > 0)
        {
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MainConn"].ConnectionString.ToString()))
            {
                conn.Open();
                using (SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM PartAttachment WHERE PApkey = @PApkey", conn))
                {
                    da.SelectCommand.Parameters.AddWithValue("@PApkey", pkey);
                    using (DataTable dt = new DataTable())
                    {
                        da.Fill(dt);
                        if (dt.Rows.Count > 0)
                        {
                            LitName.Text = dt.Rows[0]["DisplayName"].ToString();
                            Filename = dt.Rows[0]["FileName"].ToString();

                        }
                        else
                        {
                            Response.Redirect("/error.aspx?mode=notfound");
                        }

                    }
                }
            }
        }
        else
        {
            Response.Redirect("/error.aspx?mode=idnotfound");
        }



        if (Request.QueryString["delete"] != null)
        {

            if (pkey > 0)
            {
                if (Filename.Length > 0)
                {
                    if (System.IO.File.Exists(Server.MapPath(Filename))) {
                        System.IO.File.Delete(Server.MapPath(Filename));
                    }
                }
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MainConn"].ConnectionString.ToString()))
                {
                    conn.Open();
                    using (SqlCommand cmd = new SqlCommand("DELETE FROM PartAttachment WHERE PApkey=@PApkey", conn))
                    {
                        cmd.Parameters.AddWithValue("@PApkey", Helpers.QueryStringReturnNumber("id"));
                        cmd.ExecuteNonQuery();
                    }
                }
                Response.Redirect("done.aspx?mode=delete");
            }
        }
    }
</script>

<!DOCTYPE html>
<html lang="en">
<head runat="server">

    <title></title>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link href="/css/layout.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="container-fluid">
            
            <div class="row mb-3">
                    <div class="col-12">
                        <p>Are you sure you want to delete:</p>
                        <p>
                            <asp:Literal ID="LitName" runat="server"></asp:Literal></p>
                        <p><a href="attachmentdelete.aspx?id=<%= Helpers.QueryStringReturnNumber("id") %>&delete=true" id="Button2" class="btn btn-danger  btn-sm">Delete</a></p>
                        
                    </div>
                <asp:Literal ID="LitDeleteMsg" runat="server"></asp:Literal>
            </div>
        </div>
    </form>
</body>
</html>
