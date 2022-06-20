<%@ Page Title="Categories" Language="C#" MasterPageFile="~/MasterPage.master" %>


<script runat="server">

</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolderHeader" Runat="Server">
    <li class="breadcrumb-item"><a href="/admin/">Admin</a></li>
    <li class="breadcrumb-item active" aria-current="page">Category List</li>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server"> 
    <div class="row mb-3">
        <div class="col-12 col-md-8"><p>The Categories section allows you to manage the item categories.</p></div>
        <div class="col-12 col-md-4 text-end"></div>
      
    <div class="col-12 ">
    <div class="card mb-4">
              <div class="card-header  d-flex flex-row align-items-center justify-content-between">
                  <h4 class="card-title">Categories</h4>
                    <div>
                  <a href="treeview.aspx" class="me-3" title="Tree View"><i class="fas fa-stream"></i></a>
                    <a href="add.aspx"  class="ml-auto" title="Add new"><i class="fa fa-plus me-2"></i></a>
                        </div>
                </div>
                <div class="card-body ">
                    <!-- start content -->
                    <div class="table-responsive">
                    <table class="table border-bottom tablelinks">
    <asp:ListView ID="ListView1" runat="server" DataSourceID="SqlDataSource1">
        <LayoutTemplate>
            <tr>
<th><asp:LinkButton runat="server" ID="PCName" CommandName="Sort"
                     CommandArgument="UserName">Name</asp:LinkButton></th>
                <th><asp:LinkButton runat="server" ID="SortByPrice" CommandName="Sort"
                     CommandArgument="PCDescription">Description</asp:LinkButton></th>
                <th class="text-end"></th>
            </tr>
         <asp:PlaceHolder runat="server" ID="itemPlaceholder"></asp:PlaceHolder>
   </LayoutTemplate>
        <ItemTemplate>
           <tr>
                <td><%#Eval("PCName") %></td>
                <td><%#Eval("PCDescription") %></td>
               <td class="text-end"><a href="edit.aspx?id=<%#Eval("PCpkey") %>" ><i class="fa fa-edit text-primary "></i></a></td>
            </tr>
        </ItemTemplate>
    </asp:ListView>
    </table>
    </div>
    <div class="row">
        <div class="col-12 text-center">
    <asp:DataPager ID="it" runat="server" PagedControlID="ListView1" PageSize="15" class="btn-group btn-group-sm">
        <Fields>
            <asp:NumericPagerField ButtonType="Link" CurrentPageLabelCssClass="btn btn-primary rounded-0"  RenderNonBreakingSpacesBetweenControls="false"
                NumericButtonCssClass="btn btn-outline-primary rounded-0" ButtonCount="10" NextPageText="..." NextPreviousButtonCssClass="btn btn-default rounded-0" />
        </Fields>
    </asp:DataPager>
</div>
</div>
                    <!-- end content -->
                    </div>
        </div>
          </div>
          </div>
    
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:MainConn %>" SelectCommand="SELECT * FROM [PartCategory] ORDER BY [PCName]"></asp:SqlDataSource>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="FooterScripts" Runat="Server">

    <script>
        $(document).ready(function () {

            $('.table tr').click(function () {
                var href = $(this).find("a").attr("href");
                if (href) {
                    window.location = href;
                }
            });

        });
    </script>
</asp:Content>