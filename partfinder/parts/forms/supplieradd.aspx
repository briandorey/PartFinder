<%@ Page Language="C#" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
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
                    using (SqlCommand cmd = new SqlCommand("INSERT INTO PartSuppliers (SupplierName, URL,PartID) VALUES (@SupplierName, @URL,@PartID)", conn))
                    {
                        cmd.Parameters.AddWithValue("@SupplierName", SupplierName.Text);
                        cmd.Parameters.AddWithValue("@URL", URL.Text);
                        cmd.Parameters.AddWithValue("@PartID", Helpers.QueryStringReturnNumber("id"));
                        
                        cmd.ExecuteNonQuery();
                    }
                }
                Response.Redirect("done.aspx");
            }
            else
            {
                LitError.Text = "<div class=\"alert alert-danger\" role=\"alert\">" + ErrorMessage + "</div>";
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

                    <button runat="server" id="Button1" class="btn btn-primary "><i class="fas fa-save me-1"></i>Save</button>
                    <!-- end content -->
               </div>
    </div>
              </div>
    </form>
</body>
</html>
