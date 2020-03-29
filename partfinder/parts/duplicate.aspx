<%@ Page Language="C#" %>

<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<script runat="server"> 
    protected void Page_Load(Object Src, EventArgs E)
    {
        if (Helpers.QueryStringIsNotNull("id"))
        {
            int pkey = Helpers.QueryStringReturnNumber("id");
            if (pkey > 0)
            {
                using (DataSet ds = new DataSet()) {
                    using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["MainConn"].ConnectionString.ToString()))
                    {

                        conn.Open();
                        using (SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM Parts WHERE PartPkey = @PartPkey", conn))
                        {
                            da.SelectCommand.Parameters.AddWithValue("@PartPkey", pkey);
                            da.Fill(ds, "Parts");

                        }
                        using (SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM PartAttachment WHERE PartID = @PartID", conn))
                        {
                            da.SelectCommand.Parameters.AddWithValue("@PartID", pkey);
                            da.Fill(ds, "PartAttachment");

                        }
                        using (SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM PartParameter WHERE PartID = @PartID", conn))
                        {
                            da.SelectCommand.Parameters.AddWithValue("@PartID", pkey);
                            da.Fill(ds, "PartParameter");

                        }
                        using (SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM PartSuppliers WHERE PartID = @PartID", conn))
                        {
                            da.SelectCommand.Parameters.AddWithValue("@PartID", pkey);
                            da.Fill(ds, "PartSuppliers");

                        }
                        using (SqlDataAdapter dd = new SqlDataAdapter("SELECT * FROM View_PartsData WHERE PartPkey = @PartPkey", conn))
                        {
                            dd.SelectCommand.Parameters.Add("@PartPkey", SqlDbType.Int).Value = pkey;
                            dd.Fill(ds, "View_PartsData");

                        }


                        if (ds.Tables["Parts"].Rows.Count == 1)
                        {
                            int newpkey = CopyItem(ds, conn);
                            // Add Part Attachments




                            if (ds.Tables["PartAttachment"].Rows.Count > 0)
                            {

                                string FolderManName = ds.Tables["View_PartsData"].Rows[0]["ManufacturerName"].ToString().DirectoryName();
                                string FolderPartName = ds.Tables["View_PartsData"].Rows[0]["PartPkey"].ToString();
                                


                                string OldFolderPath = Server.MapPath("\\docs\\" + FolderManName + "\\" + FolderPartName  + "\\");
                                string NewFolderPath = Server.MapPath("\\docs\\" + FolderManName + "\\" + newpkey.ToString()  + "\\");

                                if (Directory.Exists(OldFolderPath))
                                {
                                    Copy(OldFolderPath, NewFolderPath);
                                }

                                foreach (DataRow row in ds.Tables["PartAttachment"].Rows)
                                {
                                    using (SqlCommand cmd = new SqlCommand("INSERT INTO PartAttachment (FileName, DisplayName, MIMEType, PartID, DateCreated) VALUES (@FileName, @DisplayName,  @MIMEType, @PartID, @DateCreated)", conn))
                                    {
                                        string FilePath = row["FileName"].ToString().Replace(FolderManName + "\\" + FolderPartName, FolderManName + "\\" + newpkey.ToString());
                                       
                                        cmd.Parameters.AddWithValue("@FileName", FilePath);
                                        cmd.Parameters.AddWithValue("@DisplayName", row["DisplayName"].ToString());
                                        cmd.Parameters.AddWithValue("@MIMEType", row["MIMEType"].ToString());
                                        cmd.Parameters.AddWithValue("@PartID", newpkey);
                                        cmd.Parameters.AddWithValue("@DateCreated", DateTime.Now);
                                        cmd.ExecuteNonQuery();
                                    }
                                }
                            }
                            // Add Part Parameters
                            if (ds.Tables["PartParameter"].Rows.Count  > 0)
                            {
                                foreach (DataRow row in ds.Tables["PartParameter"].Rows)
                                {
                                    using (SqlCommand cmd = new SqlCommand("INSERT INTO PartParameter (PartID, ParamName, ParamDescription, ParamValue, normalizedValue, maximumValue, normalizedMaxValue, minimumValue, normalizedMinValue) VALUES (@PartID, @ParamName,  @ParamDescription, @ParamValue, @normalizedValue, @maximumValue, @normalizedMaxValue, @minimumValue, @normalizedMinValue)", conn))
                                    {
                                        cmd.Parameters.AddWithValue("@PartID", newpkey);
                                        cmd.Parameters.AddWithValue("@ParamName", row["ParamName"].ToString());
                                        cmd.Parameters.AddWithValue("@ParamDescription", row["ParamDescription"].ToString());
                                        cmd.Parameters.AddWithValue("@ParamValue", row["ParamValue"].ToString());
                                        cmd.Parameters.AddWithValue("@normalizedValue", row["normalizedValue"].ToString());
                                        cmd.Parameters.AddWithValue("@maximumValue", row["maximumValue"].ToString());
                                        cmd.Parameters.AddWithValue("@normalizedMaxValue", row["normalizedMaxValue"].ToString());
                                        cmd.Parameters.AddWithValue("@minimumValue", row["minimumValue"].ToString());
                                        cmd.Parameters.AddWithValue("@normalizedMinValue", row["normalizedMinValue"].ToString());
                                        cmd.ExecuteNonQuery();
                                    }
                                }
                            }
                            // Add Part Suppliers
                            if (ds.Tables["PartSuppliers"].Rows.Count  > 0)
                            {
                                foreach (DataRow row in ds.Tables["PartSuppliers"].Rows)
                                {
                                    using (SqlCommand cmd = new SqlCommand("INSERT INTO PartSuppliers (SupplierName, URL, PartID) VALUES (@SupplierName, @URL, @PartID)", conn))
                                    {
                                        cmd.Parameters.AddWithValue("@SupplierName", row["SupplierName"].ToString());
                                        cmd.Parameters.AddWithValue("@URL", row["URL"].ToString());
                                        cmd.Parameters.AddWithValue("@PartID", newpkey);
                                        cmd.ExecuteNonQuery();
                                    }
                                }
                            }
                            Response.Redirect("view.aspx?id=" + newpkey.ToString());
                        }
                        else
                        {
                            Response.Write("Part not found");
                        }
                    }
                }
            }
        }
    }
    private int CopyItem(DataSet ds, SqlConnection conn)
    {
        using (SqlCommand cmd = new SqlCommand("INSERT INTO Parts (PartCategoryID, PartFootprintID,  PartManID, PartName, PartDescription, PartComment, StockLevel, MinStockLevel, Price, DateCreated, DateUpdated, Condition, StorageLocationID, MPN, BarCode) VALUES (@PartCategoryID, @PartFootprintID,  @PartManID, @PartName, @PartDescription, @PartComment, @StockLevel, @MinStockLevel, @Price, @DateCreated, @DateUpdated, @Condition, @StorageLocationID, @MPN, @BarCode)", conn))
        {
            cmd.Parameters.AddWithValue("@PartCategoryID", ds.Tables["Parts"].Rows[0]["PartCategoryID"]);
            cmd.Parameters.AddWithValue("@PartFootprintID", ds.Tables["Parts"].Rows[0]["PartFootprintID"]);
            cmd.Parameters.AddWithValue("@PartManID", ds.Tables["Parts"].Rows[0]["PartManID"]);
            cmd.Parameters.AddWithValue("@PartName", "Copy " + ds.Tables["Parts"].Rows[0]["PartName"]);
            cmd.Parameters.AddWithValue("@PartDescription", ds.Tables["Parts"].Rows[0]["PartDescription"]);
            cmd.Parameters.AddWithValue("@PartComment", ds.Tables["Parts"].Rows[0]["PartComment"]);
            cmd.Parameters.AddWithValue("@StockLevel", ds.Tables["Parts"].Rows[0]["StockLevel"]);
            cmd.Parameters.AddWithValue("@MinStockLevel", ds.Tables["Parts"].Rows[0]["MinStockLevel"]);
            cmd.Parameters.AddWithValue("@Price", ds.Tables["Parts"].Rows[0]["Price"]);
            cmd.Parameters.AddWithValue("@DateCreated", DateTime.Now);
            cmd.Parameters.AddWithValue("@DateUpdated", DateTime.Now);
            cmd.Parameters.AddWithValue("@Condition", ds.Tables["Parts"].Rows[0]["Condition"]);
            cmd.Parameters.AddWithValue("@StorageLocationID", ds.Tables["Parts"].Rows[0]["StorageLocationID"]);
            cmd.Parameters.AddWithValue("@MPN", ds.Tables["Parts"].Rows[0]["MPN"]);
            cmd.Parameters.AddWithValue("@BarCode", ds.Tables["Parts"].Rows[0]["BarCode"]);

            cmd.ExecuteNonQuery();
            cmd.CommandText = "SELECT @@Identity FROM Parts";
            Decimal iId = (decimal)cmd.ExecuteScalar();
            return Decimal.ToInt32(iId);
        }
    }

    public void Copy(string sourceDirectory, string targetDirectory)
    {
        var diSource = new DirectoryInfo(sourceDirectory);
        var diTarget = new DirectoryInfo(targetDirectory);

        CopyAll(diSource, diTarget);
    }

    public void CopyAll(DirectoryInfo source, DirectoryInfo target)
    {
        Directory.CreateDirectory(target.FullName);

        // Copy each file into the new directory.
        foreach (FileInfo fi in source.GetFiles())
        {
            Console.WriteLine(@"Copying {0}\{1}", target.FullName, fi.Name);
            fi.CopyTo(Path.Combine(target.FullName, fi.Name), true);
        }

        // Copy each subdirectory using recursion.
        foreach (DirectoryInfo diSourceSubDir in source.GetDirectories())
        {
            DirectoryInfo nextTargetSubDir =
                target.CreateSubdirectory(diSourceSubDir.Name);
            CopyAll(diSourceSubDir, nextTargetSubDir);
        }
    }
</script>

