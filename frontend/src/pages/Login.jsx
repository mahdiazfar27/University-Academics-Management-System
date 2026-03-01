// src/pages/Login.jsx
import React, { useState } from "react";
import axios from "axios";
import { useNavigate } from "react-router-dom";
import { FaUserGraduate, FaEnvelope, FaLock, FaEye, FaEyeSlash, FaArrowRight } from "react-icons/fa"; // Importing Icons
import "./Login.css"; // Import the CSS we just made

const Login = () => {
  // State for all inputs
  const [role, setRole] = useState("student");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [showPassword, setShowPassword] = useState(false);
  const [error, setError] = useState("");
  const navigate = useNavigate();

  const handleLogin = async (e) => {
    e.preventDefault();
    setError("");

    try {
        // Change URL to match your Folder Name
        const response = await axios.post(
            "http://localhost/uams_db_project/University-Academics-Management-System/backend/api/auth/login.php",
            {
                email: email,
                password: password,
            }
        );

        if (response.data.status === "success") {
            const user = response.data.user;

            // Optional: Check if the role they selected matches their real role
            if (user.role !== role) {
               setError(`Warning: You logged in successfully, but you are registered as a "${user.role}", not a "${role}".`);
               // We proceed anyway for now, or you can block it.
            }

            // Save user and redirect
            localStorage.setItem("user", JSON.stringify(user));
            navigate("/dashboard");
        }
    } catch (err) {
        if (err.response && err.response.data.message) {
            setError(err.response.data.message);
        } else {
            setError("Server Error. Make sure XAMPP is running.");
        }
    }
  };

  return (
    <div className="login-wrapper">
      <div className="login-container">
        
        {/* Header Section */}
        <div className="header">
          <FaUserGraduate className="header-icon" />
          <h2>IUMS Portal</h2>
          <p>Integrated University Management System</p>
        </div>

        <h3 style={{fontSize: '18px', marginBottom: '20px'}}>Sign In</h3>

        {/* Error Message Display */}
        {error && <div className="error-msg">{error}</div>}

        <form onSubmit={handleLogin}>
          
          {/* 1. Role Selection (Figma Style) */}
          <div className="form-group">
            <label>User Role</label>
            <div className="input-wrapper select-wrapper">
              <FaUserGraduate className="icon-left" />
              <select value={role} onChange={(e) => setRole(e.target.value)}>
                <option value="student">Student</option>
                <option value="teacher">Teacher / Faculty</option>
                <option value="admin">Admin</option>
              </select>
            </div>
          </div>

          {/* 2. Email Input */}
          <div className="form-group">
            <label>Email or Institutional ID</label>
            <div className="input-wrapper">
              <FaEnvelope className="icon-left" />
              <input
                type="email"
                placeholder="e.g. j.doe@university.edu"
                className="input-field"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                required
              />
            </div>
          </div>

          {/* 3. Password Input */}
          <div className="form-group">
            <label>Password</label>
            <div className="input-wrapper">
              <FaLock className="icon-left" />
              <input
                type={showPassword ? "text" : "password"}
                placeholder="Enter password"
                className="input-field"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                required
              />
              {/* Toggle Eye Icon */}
              <span className="icon-right" onClick={() => setShowPassword(!showPassword)}>
                {showPassword ? <FaEyeSlash /> : <FaEye />}
              </span>
            </div>
          </div>

          {/* 4. Options Row */}
          <div className="options-row">
            <label>
              <input type="checkbox" /> Keep me logged in
            </label>
            <a href="#" className="forgot-link">Forgot Password?</a>
          </div>

          {/* 5. Submit Button */}
          <button type="submit" className="login-btn">
            LOGIN TO PORTAL <FaArrowRight />
          </button>
        </form>

        <div className="footer-links">
           IT Help Desk: (555) 012-3456 • Privacy Policy
        </div>
      </div>
    </div>
  );
};

export default Login;