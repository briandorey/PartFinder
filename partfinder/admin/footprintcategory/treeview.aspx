<%@ Page Title="Footprint Categories" Language="C#" MasterPageFile="~/MasterPage.master" %>


<script runat="server">
    protected void Page_Load(object sender, EventArgs e)
    {
        FootprintCategoryHelpers nav = new FootprintCategoryHelpers();

        LitTree.Text = nav.MakeFootprintTreeMenu("/admin/footprintcategory/edit.aspx?id=");
              }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolderHeader" Runat="Server">
    <li class="breadcrumb-item"><a href="/admin/">Admin</a></li>
    <li class="breadcrumb-item"><a href="/footprintcategory/">Footprint Category</a></li>
    <li class="breadcrumb-item active" aria-current="page">Tree View</li>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server"> 
    <div class="row mb-3">
        <div class="col-12 col-md-8"><p>The Footprint Categories section allows you to manage the footprint categories for your items.</p></div>
        <div class="col-12 col-md-4 text-end"></div>
      
    <div class="col-12 ">
    <div class="card mb-4">
              <div class="card-header  d-flex flex-row align-items-center justify-content-between">
                  <h4 class="card-title">Footprint Categories</h4>
                  <div>
                  <a href="default.aspx" class="me-3" title="List View"><i class="fas fa-list"></i></a>
                    <a href="add.aspx" title="Add new"><i class="fas fa-plus"></i></a></div>
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
