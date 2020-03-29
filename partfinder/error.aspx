<%@ Page Title="Part Finder Error" Language="C#" MasterPageFile="~/MasterPage.master" %>


<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString["mode"] != null)
        {
            switch (Request.QueryString["mode"].ToString())
            {
                case "idnotfound":
                    LitError.Text = "The selected record was not found";
                    break;
                case "notfound":
                    LitError.Text = "The selected record has been deleted";
                    break;
                default:
                    Console.WriteLine("Default case");
                    break;
            }

        }

    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolderHeader" Runat="Server">
    <h3><span >Part Finder</span> <i class="fa fa-chevron-right  fa-xs mx-2"></i> Error</h3>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server"> 
    <div class="row">

    <div class="col-12 mb-4">
              <div class="card border-left-primary shadow h-100 py-2">
                <div class="card-body">
                  <div class="row no-gutters align-items-center">
                    <div class="col mr-2">
                      <div class="text-xs font-weight-bold text-primary text-uppercase mb-3">Error</div>
                      <div class="h5 mb-0 text-gray-800">
                          <asp:Literal ID="LitError" runat="server"></asp:Literal></div>
                    </div>
                    <div class="col-auto">
                        <i class="fas fa-exclamation-triangle fa-2x text-gray-300"></i>
                      
                    </div>
                  </div>
                </div>
              </div>
            </div>
        </div>

   
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="FooterScripts" Runat="Server">

  
</asp:Content>