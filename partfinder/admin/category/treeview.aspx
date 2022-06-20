<%@ Page Title="Categories" Language="C#" MasterPageFile="~/MasterPage.master" %>


<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        CategoryHelpers nav = new CategoryHelpers();

        LitTree.Text = nav.MakeTreeMenu("/admin/category/edit.aspx?id=", "/admin/category/add.aspx?parent=");
              }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolderHeader" Runat="Server">
   <li class="breadcrumb-item"><a href="/admin/">Admin</a></li>
    <li class="breadcrumb-item"><a href="/admin/category/">Category</a></li>
    <li class="breadcrumb-item active" aria-current="page">Tree View</li>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server"> 
    <div class="row mb-3">
        <div class="col-12 col-md-8"><p>The Categories section allows you to manage the item categories.</p></div>
        <div class="col-12 col-md-4 text-end"></div>
      
    <div class="col-12 ">
    <div class="card mb-4">
              <div class="card-header d-flex flex-row align-items-center justify-content-between">
                  <h4 class="card-title">Categories</h4>
                  <div>
                 <a href="default.aspx" class="me-3" title="List View"><i class="fas fa-list"></i></a>
                    <a href="add.aspx"  class="ml-auto" title="Add new"><i class="fa fa-plus me-2"></i></a>
                </div>
                  </div>
                <div class="card-body">
                    <!-- start content -->
                    <asp:Literal ID="LitTree" runat="server"></asp:Literal>
                    <!-- end content -->
                    </div>
        </div>
          </div>
          </div>
</asp:Content>
