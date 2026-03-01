// src/pages/roles/StudentDashboard.jsx
import React from 'react';

const FacultyDashboard = ({ user }) => {
  return (
    <div>
      <h1>Good morning, {user?.name || "Student"}!</h1>
      <p>Education is the most powerful weapon which you can use to change the world.</p>
      
      {/* Fake Stat Cards from your Figma */}
      <div className="stats-grid">
        <div className="stat-card">
          <h3>Cumulative GPA</h3>
          <h2>3.82</h2>
        </div>
        <div className="stat-card">
          <h3>Overall Attendance</h3>
          <h2>92%</h2>
        </div>
        <div className="stat-card">
          <h3>Total Credits</h3>
          <h2>84 / 140</h2>
        </div>
      </div>
    </div>
  );
};

export default FacultyDashboard;