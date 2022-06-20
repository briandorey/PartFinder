<%@ Page Title="Part Finder Error" Language="C#" MasterPageFile="~/MasterPage.master" %>



<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolderHeader" Runat="Server">
    Error
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server"> 
    <div class="row">

    <div class="col-12 mb-4">
              <div class="card border-left-primary h-100 py-2">
                <div class="card-body">
                  <div class="row no-gutters align-items-center">
                    <div class="col me-2">
                      <div class="text-xs font-weight-bold text-primary text-uppercase mb-3">Error</div>
                      <div class="h5 mb-0 text-gray-800">
                         <h1>Error Uploading File</h1>
    <p>The selected file was over 4Mb and cannot be uploaded. Please select a smaller file.</p></div>
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