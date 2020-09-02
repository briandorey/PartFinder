<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" %>

<script runat="server">
    protected void Page_Load(Object Src, EventArgs E)
    {
        System.Data.DataView dv = (System.Data.DataView)SqlDataSourceMain.Select(DataSourceSelectArguments.Empty);
        if (dv.Count > 0)
        {
            foreach (System.Data.DataRowView drvSql in dv)
            {
                Page.Title = drvSql["PartName"].ToString() + " on Part Finder";
                // LitPartPkey.Text = drvSql["PartPkey"].ToString();
                // LitPartCategoryID.Text = drvSql["PartCategoryID"].ToString();
                // LitPartFootprintID.Text = drvSql["PartFootprintID"].ToString();
                // LitPartManID.Text = drvSql["PartManID"].ToString();
                LitPartName.Text = drvSql["PartName"].ToString();
                LitPartDescription.Text = drvSql["PartDescription"].ToString();
                LitPartComment.Text = drvSql["PartComment"].ToString();
                LitStockLevel.Text = drvSql["StockLevel"].ToString();
                LitMinStockLevel.Text = drvSql["MinStockLevel"].ToString();
                LitPrice.Text = drvSql["Price"].ToString();
                LitDateCreated.Text = drvSql["DateCreated"].ToString().DoDateFormat();
                LitDateUpdated.Text = drvSql["DateUpdated"].ToString().DoDateFormat();
                LitCondition.Text = Helpers.GetCondition(drvSql["Condition"].ToString());
                LitManufacturerName.Text = drvSql["ManufacturerName"].ToString();
                LitFootprintName.Text = drvSql["FootprintName"].ToString();
                LitFootprintImage.Text = CheckImage(drvSql["FootprintImage"].ToString());
                //LitManufacturerLogo.Text = drvSql["ManufacturerLogo"].ToString();
                LitPCName.Text = drvSql["PCName"].ToString();
                LitMPN.Text = drvSql["MPN"].ToString();
                LitBarcode.Text = drvSql["BarCode"].ToString();
                HyperLinkLocation.NavigateUrl = "/parts/listbystoragelocation.aspx?id=" + drvSql["StorageLocationID"].ToString();
                HyperLinkLocation.Text = drvSql["StorageName"].ToString();
            }
        }
        else
        {
            Response.Redirect("/parts/default.aspx?mode=delete");
        }
    }
     public string CheckImage(string inval)
    {
        if (inval.Trim().Length > 0)
        {
            return "<br><img src=\"" + inval + "\" class=\"img-fluid\" />";
        }
        else
        {
            return "";
        }
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style>
        .modal {
            padding: 0 !important;
        }
        .modal-dialog {
            max-width: 80% !important;
            height: 80%;
            padding: 0;
            margin: 5% 10% 0 10%;
        }
        .modal-content {
            height: 100%;
        }
        #TargetFrame {
            width: 100%;
            height: 100%;
            overflow: auto;
            border: none;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolderHeader" runat="Server">
    <li class="breadcrumb-item"><a href="/parts/">Parts</a></li>
    <li class="breadcrumb-item active" aria-current="page">Part Details</li>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="row mb-3">
        <div class="col-12 col-md-8 ">
            <!-- start card -->
            <div class="card mb-4">
                <div class="card-header  d-flex flex-row align-items-center justify-content-between">
                    <h4 class="card-title">Part Information</h4>
                    
                    <div>
                       
                        <a href="javascript:LoadModal('partedit.aspx?id=<%= Helpers.QueryStringReturnNumber("id") %>', 'Edit Part');" class=" ml-auto"><i class="fas fa-edit mr-1"></i></a>
                    </div>
                </div>
                <div class="card-body">
                    <!-- start content -->
                    <h1 class="mb-3 font-weight-light">
                        <asp:Literal ID="LitPartName" runat="server"></asp:Literal></h1>
                    <div class="row border-bottom pb-2 mb-3">
                        <div class="col-12 col-md-4">
                            <p>
                                <strong>MPN:</strong><br />
                                <asp:Literal ID="LitMPN" runat="server"></asp:Literal>
                            </p>
                            <p>
                                <strong>Manufacturer:</strong><br />
                                <asp:Literal ID="LitManufacturerName" runat="server"></asp:Literal>
                            </p>
                            <p>
                                <strong>Barcode:</strong><br />
                                <asp:Literal ID="LitBarcode" runat="server"></asp:Literal>
                            </p>

                        </div>
                        <div class="col-12 col-md-4">
                            <p>
                                <strong>Stock Level:</strong><br />
                                <asp:Literal ID="LitStockLevel" runat="server"></asp:Literal>
                            </p>
                            <p>
                                <strong>Min Stock Level:</strong><br />
                                <asp:Literal ID="LitMinStockLevel" runat="server"></asp:Literal>
                            </p>
                            <p>
                                <strong>Price:</strong><br />
                                $<asp:Literal ID="LitPrice" runat="server"></asp:Literal>
                            </p>

                        </div>
                        <div class="col-12 col-md-4">
                            <p>
                                <strong>Footprint:</strong><br />
                                <asp:Literal ID="LitFootprintName" runat="server"></asp:Literal>
                                <asp:Literal ID="LitFootprintImage" runat="server"></asp:Literal>
                            </p>
                            <p>
                                <strong>Category:</strong><br />
                                <asp:Literal ID="LitPCName" runat="server"></asp:Literal>
                            </p>
                            <p>
                                <strong>Location:</strong><br />
                                <asp:HyperLink ID="HyperLinkLocation" runat="server"></asp:HyperLink>
                            </p>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-12 col-md-4">
                            <p>
                                <strong>Description:</strong><br />
                                <asp:Literal ID="LitPartDescription" runat="server"></asp:Literal>
                            </p>

                        </div>
                        <div class="col-12 col-md-4">
                            <p>
                                <strong>Notes:</strong><br />
                                <asp:Literal ID="LitPartComment" runat="server"></asp:Literal>
                            </p>

                        </div>
                        <div class="col-12 col-md-4">
                            <p>
                                <strong>Date Created:</strong><br />
                                <asp:Literal ID="LitDateCreated" runat="server"></asp:Literal>
                            </p>
                            <p>
                                <strong>Last Updated:</strong><br />
                                <asp:Literal ID="LitDateUpdated" runat="server"></asp:Literal>
                            </p>
                            <p>
                                <strong>Condition:</strong><br />
                                <asp:Literal ID="LitCondition" runat="server"></asp:Literal>
                            </p>
                        </div>
                    </div>




                    <!-- end content -->
                </div>
            </div>
            <!-- end card -->
            <!-- start card -->
            <div class="card mb-4">
                <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                    <h4 class="card-title">Parameters</h4>
                    <div>
                        <a href="javascript:LoadModal('parameteradd.aspx?id=<%= Helpers.QueryStringReturnNumber("id") %>', 'Add Parameter');" title="add" class="ml-auto"><i class="fas fa-plus"></i></a>
                    </div>
                </div>
                <div class="card-body ">
                    <!-- start content -->
                    <div class="table-responsive">
                        <table class="table border-bottom">
                            <tr>
                                        <th><strong>Name</strong></th>
                                        <th>Value</th>
                                <th></th>
                                </tr>
                            <asp:ListView ID="ListView1" runat="server" DataSourceID="SqlDataSourceParameters">
                                <ItemTemplate>
                                    <tr>
                                        <td>
                                            <%#Eval("ParamName") %>
                                        </td>
                                        <td><%#Eval("ParamValue") %></td>
                                        <td class="text-right">
                                            <a href="javascript:LoadModal('parameteredit.aspx?id=<%#Eval("PPpkey") %>', 'Edit Parameter');" title="Edit"><i class="fas fa-edit mr-1"></i></a></td>

                                    </tr>
                                   
                                </ItemTemplate>
                            </asp:ListView>
                        </table>
                    </div>
                    <!-- end content -->
                </div>
            </div>
            <!-- end card -->
        </div>


        <div class="col-12 col-md-4 ">
            <!-- start card -->
            <div class="card mb-4">
                <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                    <h4 class="card-title">Attachments</h4>
                    <div>
                        <a href="javascript:LoadModal('attachmentadd.aspx?id=<%= Helpers.QueryStringReturnNumber("id") %>', 'Add Attachment');" title="Add" class="ml-auto"><i class="fas fa-plus"></i></a>
                    </div>
                </div>
                <div class="card-body ">
                    <!-- start content -->
                    <table class="table border-bottom">
                        <tr>
                            <th>Name</th>
                            <th>MIME Type</th>
                            <th>Date Created</th>
                            <th></th>
                        </tr>
                        <asp:ListView ID="ListViewAttachments" runat="server" DataSourceID="SqlDataSourceAttachments">
                            <ItemTemplate>
                                <tr>
                                    <td><a href="<%#Eval("FileName") %>" target="_blank"><%#Eval("DisplayName") %></a></td>

                                    <td><%#Eval("MIMEType") %></td>
                                    <td><%# Eval("DateCreated").ToString().DoDateFormat() %></td>
                                    <td class="text-right">
                                        <a href="javascript:LoadModal('attachmentdelete.aspx?id=<%#Eval("PApkey") %>', 'Delete Attachment');" title="Edit"><i class="fas fa-trash text-danger"></i></a></td>

                                </tr>
                            </ItemTemplate>
                        </asp:ListView>
                    </table>
                    <!-- end content -->
                </div>
            </div>
            <!-- end card -->

            <!-- start card -->
            <div class="card mb-4">
                <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                    <h4 class="card-title">Suppliers</h4>
                    <div>
                        <a href="javascript:LoadModal('supplieradd.aspx?id=<%= Helpers.QueryStringReturnNumber("id") %>', 'Add Supplier');" title="Edit" class="ml-auto"><i class="fas fa-plus"></i></a>
                    </div>
                </div>
                <div class="card-body ">
                    <!-- start content -->
                    <table class="table border-bottom">
                        <tr>
                            <th>Name</th>
                            <th></th>
                        </tr>
                        <asp:ListView ID="ListView2" runat="server" DataSourceID="SqlDataSourceSuppliers">
                            <ItemTemplate>
                                <tr>
                                    <td><a href="<%#Eval("URL") %>" target="_blank"><%#Eval("SupplierName") %></a></td>
                                    <td class="text-right"><a href="javascript:LoadModal('supplieredit.aspx?id=<%#Eval("SupPkey") %>', 'Edit Supplier');" title="Edit"><i class="fas fa-edit mr-1"></i></a></td>

                                </tr>
                            </ItemTemplate>
                        </asp:ListView>
                    </table>
                    <!-- end content -->
                </div>
            </div>
            <!-- end card -->

            <!-- start card -->
            <div class="card mb-4">
                <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                    <h4 class="card-title">Stock Level Change History</h4>
                  
                </div>
                <div class="card-body ">
                    <!-- start content -->
                    <table class="table border-bottom">
                        <tr>
                            <th>Date</th>
                            <th>Stock Level</th>
                            <th>User</th>
                        </tr>
                        <asp:ListView ID="ListViewStockLevel" runat="server" DataSourceID="SqlDataSourceStockChanges">
                            <ItemTemplate>
                                <tr>
                                    <td><%# DateTime.Parse(Eval("DateChanged").ToString()).ToString("MM/dd/yyyy - hh:mm tt") %></td>
                                    <td><%# Eval("StockLevel") %></td>
                                    <td><%#Eval("Name") %></td>

                                </tr>
                            </ItemTemplate>
                        </asp:ListView>
                    </table>
                    <div class="text-center">
                    <asp:DataPager ID="it" runat="server" QueryStringField="page" PagedControlID="ListViewStockLevel" PageSize="5" class="btn-group btn-group-sm" >
                                <Fields>
                                    <asp:NumericPagerField ButtonType="Link" CurrentPageLabelCssClass="btn btn-primary rounded-0" RenderNonBreakingSpacesBetweenControls="false" 
                                        NumericButtonCssClass="btn btn-outline-primary rounded-0" ButtonCount="10" NextPageText="..." NextPreviousButtonCssClass="btn btn-default rounded-0" />
                                </Fields>
                            </asp:DataPager></div>
                    <!-- end content -->
                </div>
            </div>
            <!-- end card -->

            <!-- start card -->
            <div class="card mb-4">
                <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                    <h4 class="card-title">Duplicate Part</h4>
                </div>
                <div class="card-body">
                    <!-- start content -->
                    <p>To create a duplicate of this part, click the button below:</p>
                    <p class="text-center mb-0">
                     <a href="duplicate.aspx?id=<%= Helpers.QueryStringReturnNumber("id") %>" title="Duplicate Part" class="btn btn-sm btn-secondary "><i class="fas fa-copy mr-1 text-white"></i> Duplicate</a></p>
                    <!-- end content -->
                </div>
            </div>
            <!-- end card -->

            
        </div>

    </div>
    <asp:SqlDataSource ID="SqlDataSourceMain" runat="server" ConnectionString="<%$ ConnectionStrings:MainConn %>" SelectCommand="SELECT * FROM View_PartsData WHERE (PartPkey = @PartPkey)">
        <SelectParameters>
            <asp:QueryStringParameter DefaultValue="0" Name="PartPkey" QueryStringField="id" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="SqlDataSourceAttachments" runat="server" ConnectionString="<%$ ConnectionStrings:MainConn %>" SelectCommand="SELECT * FROM PartAttachment WHERE (PartID = @PartID) ORDER BY FileName ASC">
        <SelectParameters>
            <asp:QueryStringParameter DefaultValue="0" Name="PartID" QueryStringField="id" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="SqlDataSourceParameters" runat="server" ConnectionString="<%$ ConnectionStrings:MainConn %>" SelectCommand="SELECT * FROM PartParameter WHERE (PartID = @PartID) ORDER BY ParamName ASC">
        <SelectParameters>
            <asp:QueryStringParameter DefaultValue="0" Name="PartID" QueryStringField="id" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSourceSuppliers" runat="server" ConnectionString="<%$ ConnectionStrings:MainConn %>" SelectCommand="SELECT * FROM PartSuppliers WHERE (PartID = @PartID) ORDER BY SupplierName ASC">
        <SelectParameters>
            <asp:QueryStringParameter DefaultValue="0" Name="PartID" QueryStringField="id" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:SqlDataSource ID="SqlDataSourceStockChanges" runat="server" ConnectionString="<%$ ConnectionStrings:MainConn %>" SelectCommand="SELECT * FROM PartStockLevelHistory WHERE (PartPkey = @PartPkey) ORDER BY DateChanged ASC">
        <SelectParameters>
            <asp:QueryStringParameter DefaultValue="0" Name="PartPkey" QueryStringField="id" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>

    
    <!-- Modal -->
    <div class="modal fade" id="ModalOverlay" tabindex="-1" role="dialog" aria-labelledby="ModalOverlay" aria-hidden="true">
        <div class="modal-dialog rounded" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="ModalOverlayTitle">Modal title</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <iframe id="TargetFrame"></iframe>
                </div>

            </div>
        </div>
    </div>
    <!-- End Modal -->
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="FooterScripts" runat="Server">

    <script>
        function LoadModal(url, modaltitle) {
            $('#ModalOverlayTitle').html(modaltitle);
            var $iframe = $('#TargetFrame');
            if ($iframe.length) {
                $iframe.attr('src', '/parts/forms/' + url);    // here you can change src
            }
            $('#ModalOverlay').modal('show')
        }
        window.closeModal = function () {
            $('#ModalOverlay').modal('hide');
            location.reload();
        };
    </script>
</asp:Content>
