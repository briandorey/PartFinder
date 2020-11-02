<%@ Page Language="C#" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.Net.Mail" %>

<script runat="server">

    // barcode scanner addon
    // Using android app from https://play.google.com/store/apps/details?id=no.winternet.barcodescannerterminal3
    // This app is purchased on an annual subscription model
    // This is the only app found so far which allows posting to a remote server
    // set server url to be https://yourdomain.com/barcode/?data=%barcode%&id=%scannerID%&qty=%qty%&mode=%scanpoint%
    // Enable number keypad on the app to enter new stock level before scanning barcode and updating the database.
    // Enable "Use multiple scan points" to use add and subtact mode. Add &mode=%scanpoint% to the server url to use this function
    // Scanning without entering a stock level number will return the current stock level.
    // 
    protected void Page_Load(object sender, EventArgs e)
    {
        Helpers.DoLog(Request.QueryString.ToString());
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
                                    int OldStockLevel = Int32.Parse(dt.Rows[0]["StockLevel"].ToString());
                                    int SaveQuantity = NewQuantity;
                                    Helpers.DoLog(Helpers.CleanQS("mode"));
                                    // Check if "Use multiple scan points" mode is active
                                    if ((Helpers.QueryStringIsNotNull("mode") && Request.QueryString["mode"].Length > 0) && (Helpers.QueryStringIsNotNull("qty") && Request.QueryString["qty"].Length > 0))
                                    {
                                        string UpdateMode = Helpers.CleanQS("mode");


                                        if (UpdateMode.Equals("in"))
                                        {
                                            SaveQuantity = OldStockLevel + NewQuantity;
                                        } else
                                        {
                                            SaveQuantity = OldStockLevel - NewQuantity;
                                        }

                                        using (SqlCommand cmd = new SqlCommand("UPDATE Parts SET StockLevel=@StockLevel WHERE PartPkey=@PartPkey", conn))
                                        {
                                            cmd.Parameters.AddWithValue("@StockLevel", SaveQuantity);

                                            cmd.Parameters.AddWithValue("@PartPkey", dt.Rows[0]["PartPkey"].ToString());
                                            cmd.ExecuteNonQuery();
                                        }

                                    } else {


                                        using (SqlCommand cmd = new SqlCommand("UPDATE Parts SET StockLevel=@StockLevel WHERE PartPkey=@PartPkey", conn))
                                        {
                                            cmd.Parameters.AddWithValue("@StockLevel", SaveQuantity);

                                            cmd.Parameters.AddWithValue("@PartPkey", dt.Rows[0]["PartPkey"].ToString());
                                            cmd.ExecuteNonQuery();
                                        }
                                    }


                                    Response.Clear();
                                    Response.ContentType = "application/json; charset=utf-8";
                                    Response.Write("{\"status\":\"ok\",\"result_msg\":\"Stock Level is now " + SaveQuantity.ToString() + "\"}");
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