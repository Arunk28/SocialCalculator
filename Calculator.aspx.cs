using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Web.Services;
using System.Net;
using System.Net.Sockets;

public partial class Calculator : System.Web.UI.Page
{
    static string constr = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;
    static SqlConnection mycon = new SqlConnection(constr);

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["login"] != null)
        {
            if (!IsPostBack)
            {
                DataTable dtLog = LoginData(Session["login"].ToString());
                if (dtLog.Rows.Count > 0)
                {        
                    if(dtLog.Rows[0]["Name"].ToString() == Session["login"].ToString())
                        hdnUid.Value = dtLog.Rows[0]["id"].ToString();
                }
                else
                    Response.Redirect("Login.aspx", false);
            }
        }
        else
            Response.Redirect("Login.aspx", false);                    
    }
    
    public DataTable LoginData(string uname)
    {
        mycon.Open();
        SqlCommand cmd = new SqlCommand();
        cmd.Connection = mycon;
        cmd.CommandType = CommandType.Text;
        cmd.CommandText = "SELECT id,Name,Password FROM users_tbl WHERE Name='" + uname.Trim() + "'";
        SqlDataAdapter da = new SqlDataAdapter(cmd);
        DataTable dt = new DataTable();
        da.Fill(dt);
        mycon.Close();
        if (dt.Rows.Count > 0)
        {
            return dt;
        }
        return dt;
    }


    [WebMethod]
    public static bool StoreCalc(string uid, string Expression, string Value)
    {
        try
        {
            if (Expression != string.Empty)
            {
                string ipv4Address = GetIPv4Address();
                mycon.Open();
                string strquery = "INSERT into dbo.Calculator_tbl (uid,Expression,IpAddress,Date) values('" + uid + "','" + Expression + " = " + Value + "','" + ipv4Address + "','" + DateTime.Now + "');";
                SqlCommand cmd = new SqlCommand(strquery, mycon);
                cmd.ExecuteNonQuery();
                mycon.Close();
                return true;
            }
                    
        }
        catch (Exception ex)
        {
            mycon.Close();
        }
        return false;
    }

    [WebMethod]
    public static string DisplayResult(string uid)
    {
        mycon.Open();
        SqlCommand cmd = new SqlCommand();
        cmd.Connection = mycon;
        cmd.CommandType = CommandType.Text;
        cmd.CommandText = "SELECT Expression,IpAddress,Date From Calculator_tbl ORDER BY Date DESC";
        SqlDataAdapter da = new SqlDataAdapter(cmd);
        DataTable dt = new DataTable();
        da.Fill(dt);
        mycon.Close();
        string tblResult = string.Empty;
        if (dt.Rows.Count > 0)
        {
            foreach (DataRow drow in dt.Rows)
            {
                tblResult += "<tr>";
                tblResult += "<td>" + drow["Expression"].ToString() + "</td>";
                tblResult += "<td>" + drow["IpAddress"].ToString() + "</td>";
                tblResult += "<td>" + Convert.ToDateTime(drow["Date"].ToString()).ToString("dd-MM-yyyy hh:mm tt") + "</td>";
                tblResult += "</tr>";
            }
        }
        else
        {
            tblResult += "<tr>";
            tblResult += "<td colspan='3' style='text-align:center;'> - No records - </td>";
            tblResult += "</tr>";
        }
        return tblResult;
    }
    public static string GetIPv4Address()
    {
        try
        {
            IPAddress localAddress = null;
            foreach (IPAddress address in Dns.GetHostEntry(Dns.GetHostName()).AddressList)
            {
                if (address.AddressFamily == AddressFamily.InterNetwork)
                {
                    localAddress = address;
                    return address.ToString();
                }
            }
        }
        catch (Exception ex)
        {

        }
            return string.Empty;
        
    }
    protected void login_Click(object sender, EventArgs e)
    {
        Session["login"] = null;
        Response.Redirect("Login.aspx", false);
    }
}
