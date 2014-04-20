using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;

public partial class Login : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["login"] != null)
            Response.Redirect("Calculator.aspx", false);
    }
    static string constr = ConfigurationManager.ConnectionStrings["constr"].ConnectionString;
    static SqlConnection mycon = new SqlConnection(constr);
    [WebMethod]
    public static bool Signup(string uname, string password)
    {
        try
        {
            if (uname != string.Empty && password != string.Empty)
            {
                bool AlreadyLogin = CheckLogin(uname);
                Page objpage = new Page();
                if (AlreadyLogin == false)
                {
                    mycon.Open();
                    string strquery = "INSERT into dbo.users_tbl (Name,Password) values('" + uname.Trim() + "','" + password.Trim() + "');";
                    SqlCommand cmd = new SqlCommand(strquery, mycon);
                    cmd.ExecuteNonQuery();
                    mycon.Close();
                    objpage.Session["login"] = uname.Trim().ToString();
                    return true;
                }
                return false;
            }
        }
        catch( Exception ex)
        {
            mycon.Close();            
        }
        return false;
    }

    [WebMethod]
    public static bool login(string uname, string password)
    {
        try
        {
            bool loginSuccess =  CheckLogin(uname, password);
            Page objpage = new Page();
            if (loginSuccess == true)
            {
                objpage.Session["login"] = uname.Trim().ToString();
                return loginSuccess;
            }
        }
        catch (Exception ex)
        {
            mycon.Close();  
        }
        return false;
    }

    public static bool CheckLogin(string uname, string password)
    {
        mycon.Open();
        SqlCommand cmd = new SqlCommand();
        cmd.Connection = mycon;
        cmd.CommandType = CommandType.Text;
        cmd.CommandText = "SELECT Name,Password FROM users_tbl WHERE Name='" + uname.Trim() + "' AND Password = '" + password.Trim() + "'";
        SqlDataAdapter da = new SqlDataAdapter(cmd);
        DataTable dt = new DataTable();
        mycon.Close();
        da.Fill(dt);
        if (dt.Rows.Count > 0)
        {
            if (dt.Rows[0]["Name"].ToString() == uname.Trim() && dt.Rows[0]["Password"].ToString() == password.Trim())
                return true;
            else
                return false;
        }
        return false;
    }


    public static bool CheckLogin(string uname)
    {
        mycon.Open();
        SqlCommand cmd = new SqlCommand();
        cmd.Connection = mycon;
        cmd.CommandType = CommandType.Text;
        cmd.CommandText = "SELECT Name,Password FROM users_tbl WHERE Name='" + uname.Trim() + "'";
        SqlDataAdapter da = new SqlDataAdapter(cmd);
        DataTable dt = new DataTable();
        da.Fill(dt);
        mycon.Close();
        if (dt.Rows.Count > 0)
        {
            if (dt.Rows[0]["Name"].ToString() == uname.Trim())
                return true;
            else
                return false;
        }
        return false;
    }
}
