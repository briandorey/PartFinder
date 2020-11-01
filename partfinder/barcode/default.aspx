<%@ Page Language="C#" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.Net.Mail" %>

<script runat="server">

    // barcode scanner addon
    // Using android app from https://play.google.com/store/apps/details?id=no.winternet.barcodescannerterminal3
    // set server url to be https://yourdomain.com/barcode/?code=%barcode%&id=%scannerID%&qty=%qty%
    // Enable number keypad on the app to enter new stock level before scanning barcode and updating the database.
    // Scanning without entering a stock level number will return the current stock level.
    // 
    protected void Page_Load(object sender, EventArgs e)
    {
        // check if scanner ID is valid
        if (CheckID())
        {
            if (Helpers.QueryStringIsNotNull("data"))
            {
                using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MainConn"].ConnectionString.ToString()))
                {
                    conn.Open();
                    using (SqlDataAdapter da = new SqlDataAdapter("SELECT PartPkey, BarCode, StockLevel FROM Parts WHERE BarCode = @BarCode", conn))
                    {
                        da.SelectCommand.Parameters.AddWithValue("@BarCode", Helpers.CleanQS("data"));
                        using (DataTable dt = new DataTable())
                        {
                            da.Fill(dt);
                            if (dt.Rows.Count > 0)
                            {

                                if (Helpers.QueryStringIsNotNull("qty") && Request.QueryString["qty"].Length > 0)
                                {
                                    int NewQuantity = Helpers.QueryStringReturnNumber("qty");


                                    using (SqlCommand cmd = new SqlCommand("UPDATE Parts SET StockLevel=@StockLevel WHERE PartPkey=@PartPkey", conn))
                                    {
                                        cmd.Parameters.AddWithValue("@StockLevel", NewQuantity);

                                        cmd.Parameters.AddWithValue("@PartPkey", dt.Rows[0]["PartPkey"].ToString());
                                        cmd.ExecuteNonQuery();
                                    }

                                    Response.Clear();
                                    Response.ContentType = "application/json; charset=utf-8";
                                    Response.Write("{\"status\":\"ok\",\"result_msg\":\"Stock Level is now " + NewQuantity.ToString() + "\"}");
                                    Response.End();
                                }
                                else
                                {
                                    // return current stock level
                                    Response.Clear();
                                    Response.ContentType = "application/json; charset=utf-8";
                                    Response.Write("{\"status\":\"ok\",\"result_msg\":\"Stock Level is " + dt.Rows[0]["StockLevel"].ToString() + "\"}");
                                    Response.End();
                                }
                            }
                            else
                            {
                                Response.Clear();
                                Response.ContentType = "application/json; charset=utf-8";
                                Response.Write("{\"status\":\"error\",\"err_msg\":\"Barcode not found\"}");
                                Response.End();
                            }

                        }
                    }
                }
            }
            else
            {
                Response.Clear();
                Response.ContentType = "application/json; charset=utf-8";
                Response.Write("{\"status\":\"error\",\"err_msg\":\"URL Error\"}");
                Response.End();
            }
        }
        else
        {
            Response.Clear();
            Response.ContentType = "application/json; charset=utf-8";
            Response.Write("{\"status\":\"error\",\"err_msg\":\"Invalid Scanner ID\"}");
            Response.End();
        }
    }

    public bool CheckID()
    {
        if (Helpers.QueryStringIsNotNull("id"))
        {
            // add the scanner IDs from the barcode scanner app to auth the device
            string[] ScannerIDs = { "1e997891e628106a", "1e997891e628106a1", "1e997891e628106a2", "1e997891e628106a3" };
            string ScannerID = Helpers.CleanQS("id");
            for (int i = 0; i < ScannerIDs.Length; i++)
            {
                if (ScannerID.Equals(ScannerIDs[i]))
                {
                    return true;
                }
            }
        }
        return false;
    }
</script>