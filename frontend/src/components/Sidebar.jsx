// src/components/Sidebar.jsx
import React from 'react';
import { useNavigate } from 'react-router-dom';
import { FaGraduationCap, FaHome, FaBook, FaCalendarAlt, FaSignOutAlt } from 'react-icons/fa';

const Sidebar = ({ userRole }) => {
  const navigate = useNavigate();

  const handleLogout = () => {
    localStorage.removeItem("user"); // Clear saved login
    navigate("/"); // Send back to login
  };

  return (
    <div className="sidebar">
      <div className="sidebar-logo">
        <FaGraduationCap size={24} /> <h2>IUMS Portal</h2>
      </div>

    <ul className="sidebar-menu">
        <li className="active"><FaHome /> <span>Dashboard</span></li>
        <li><FaCalendarAlt /> <span>Schedule</span></li>
        <li><FaBook /> <span>{userRole === 'student' ? "My Courses" : "Library"}</span></li>
    </ul>

    <div className="sidebar-footer" onClick={handleLogout}>
        <FaSignOutAlt /> <span>Logout</span>
      </div>
    </div>
  );
};

export default Sidebar;