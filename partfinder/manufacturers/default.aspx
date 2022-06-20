<%@ Page Title="Manufacturers" Language="C#" MasterPageFile="~/MasterPage.master" %>


<script runat="server">

</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolderHeader" Runat="Server">
   <li class="breadcrumb-item active" aria-current="page">Manufacturers List</li>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server"> 
   
    <div class="row mb-3">
    <div class="col-12 ">
    <div class="card mb-4">
              <div class="card-header d-flex flex-row align-items-center justify-content-between">
                  <h4 class="card-title">Manufacturers</h4>
                    <div>
                    <a href="/admin/manufacturers/add.aspx" class="ml-auto" title="Add new"><i class="fas fa-plus"></i></a>
                        </div>
                </div>
                <div class="card-body">
                    <!-- start content -->
                    <div class="table-responsive">
                    <table class="table border-bottom tablelinks">
     <asp:ListView ID="ListView1" runat="server" DataSourceID="SqlDataSource1">
        <LayoutTemplate>
            <tr>
<th><asp:LinkButton runat="server" ID="SortByManufacturerName" CommandName="Sort"
                     CommandArgument="ManufacturerName">Name</asp:LinkButton></th>
                <th><asp:LinkButton runat="server" ID="LinkButton1" CommandName="Sort"
                     CommandArgument="ManufacturerURL">URL</asp:LinkButton></th>
                <th><asp:LinkButton runat="server" ID="LinkButton2" CommandName="Sort"
                     CommandArgument="ManufacturerPhone">Phone</asp:LinkButton></th>
               
                <th class="text-end"></th>
            </tr>
         <asp:PlaceHolder runat="server" ID="itemPlaceholder"></asp:PlaceHolder>
   </LayoutTemplate>
        <ItemTemplate>
           <tr>
                <td><%#Eval("ManufacturerName") %></td>
               <td><a href="<%#Eval("ManufacturerURL") %>" target="_blank"><%#Eval("ManufacturerURL") %></a></td>
               <td><%#Eval("ManufacturerPhone") %></td>
              
               
             <td class="text-end"><a href="/parts/listbymanufacturer.aspx?id=<%#Eval("mpkey") %>" ><i class="fa fa-list text-primary fa-1x "></i> View Parts</a></td>
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
    
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:MainConn %>" SelectCommand="SELECT * FROM [Manufacturer] ORDER BY [ManufacturerName]"></asp:SqlDataSource>
</asp:Content>
