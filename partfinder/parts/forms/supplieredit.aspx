<%@ Page Language="C#" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack)
        {
            int pkey = Helpers.QueryStringReturnNumber("id");
            if (pkey > 0)
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MainConn"].ConnectionString.ToString()))
                {
                    conn.Open();
                    using (SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM PartSuppliers WHERE SupPkey = @SupPkey", conn))
                    {
                        da.SelectCommand.Parameters.AddWithValue("@SupPkey", pkey);
                        using (DataTable dt = new DataTable())
                        {
                            da.Fill(dt);
                            if (dt.Rows.Count > 0)
                            {
                                SupplierName.Text = dt.Rows[0]["SupplierName"].ToString();
                                URL.Text = dt.Rows[0]["URL"].ToString();

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
        }
        if (IsPostBack)
        {
            string ErrorMessage = "";
            bool DoSave = true;

            if (Helpers.TextBoxIsNull(SupplierName))
            {
                DoSave = false;
                ErrorMessage += "<p>Please enter your supplier name.</p>";
            }
            if (Helpers.TextBoxIsNull(URL))
            {
                DoSave = false;
                ErrorMessage += "<p>Please enter your supplier URL.</p>";
            }



            if (DoSave)
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MainConn"].ConnectionString.ToString()))
                {
                    conn.Open();
                    using (SqlCommand cmd = new SqlCommand("UPDATE PartSuppliers SET SupplierName=@SupplierName ,URL=@URL WHERE SupPkey=@SupPkey", conn))
                    {
                        cmd.Parameters.AddWithValue("@SupplierName", SupplierName.Text);
                        cmd.Parameters.AddWithValue("@URL", URL.Text);
                        cmd.Parameters.AddWithValue("@SupPkey", Helpers.QueryStringReturnNumber("id"));
                        cmd.ExecuteNonQuery();
                    }
                }
                Response.Redirect("done.aspx?mode=update");
            }
            else
            {
                LitError.Text = "<div class=\"alert alert-danger\" role=\"alert\">" + ErrorMessage + "</div>";
            }
        }

        if (Request.QueryString["delete"] != null)
        {
            int pkey = Helpers.QueryStringReturnNumber("id");
            if (pkey > 0)
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MainConn"].ConnectionString.ToString()))
                {
                    conn.Open();
                    using (SqlCommand cmd = new SqlCommand("DELETE FROM PartSuppliers WHERE SupPkey=@SupPkey", conn))
                    {
                        cmd.Parameters.AddWithValue("@SupPkey", Helpers.QueryStringReturnNumber("id"));
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
    <link href="/css/styles.css" rel="stylesheet" />
    <link href="/css/custom.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="container-fluid">
            <div class="row mb-3">
                <div class="col-12 ">

                    <!-- start content -->
                    <asp:Literal ID="LitError" runat="server"></asp:Literal>

                    <div class="mb-3">
                        <label for="<%= SupplierName.ClientID %>">Name</label>
                        <asp:TextBox ID="SupplierName" CssClass="form-control form-control-sm" runat="server" placeholder="Name" MaxLength="250" required></asp:TextBox>

                    </div>
                    <div class="mb-3">
                        <label for="<%= URL.ClientID %>">URL</label>
                        <asp:TextBox ID="URL" CssClass="form-control form-control-sm" runat="server" Text="https://" MaxLength="250" required></asp:TextBox>
                    </div>


                    <!-- end content -->
                </div>
            </div>
            <div class="row mb-3">
                <div class="col-6">
                    <button runat="server" id="Button1" class="btn btn-primary ">Save</button>
                    </div>
                    <div class="col-6 text-end">
                        <a href="supplieredit.aspx?id=<%= Helpers.QueryStringReturnNumber("id") %>&delete=true" id="Button2" class="btn btn-danger  btn-sm">Delete</a>
                        
                    </div>
                <asp:Literal ID="LitDeleteMsg" runat="server"></asp:Literal>
            </div>
        </div>
    </form>
</body>
</html>
