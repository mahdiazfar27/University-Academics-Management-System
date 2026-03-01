// src/pages/Dashboard.jsx
import React, { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import Sidebar from "../components/Sidebar";
import StudentDashboard from "./roles/StudentDashboard";
// import AdminDashboard from "./roles/AdminDashboard"; // (uncomment when created)
// import FacultyDashboard from "./roles/FacultyDashboard"; // (uncomment when created)
import "./Dashboard.css";

const Dashboard = () => {
  const navigate = useNavigate();
  const [user, setUser] = useState(null);

  // When component loads, check if user is logged in
  useEffect(() => {
    const loggedInUser = localStorage.getItem("user");
    if (!loggedInUser) {
      navigate("/"); // Kick out to login if no data found
    } else {
      setUser(JSON.parse(loggedInUser)); // Load data into state
    }
  }, [navigate]);

  if (!user) return <div>Loading...</div>; // Show nothing until verified

  // Determine which dashboard content to show
  const renderDashboardContent = () => {
    if (user.role === "student") return <StudentDashboard user={user} />;
    if (user.role === "admin") return <h2>Admin Overview Coming Soon</h2>; // <AdminDashboard user={user} />;
    if (user.role === "teacher") return <h2>Faculty Dashboard Coming Soon</h2>; // <FacultyDashboard user={user} />;
    return <h2>Unknown Role</h2>;
  };

  return (
    <div className="dashboard-layout">
      {/* 1. Static Sidebar on the left */}
      <Sidebar userRole={user.role} />

      {/* 2. Dynamic Content on the right */}
      <div className="dashboard-content">
        <div className="top-header">
           <span>Home &gt; Dashboard Overview</span>
           <div className="user-profile-badge">
              <strong>{user.name}</strong> ({user.role})
           </div>
        </div>

        {/* Traffic Cop drops the right page here */}
        <div className="main-area">
           {renderDashboardContent()}
        </div>
      </div>
    </div>
  );
};

export default Dashboard;