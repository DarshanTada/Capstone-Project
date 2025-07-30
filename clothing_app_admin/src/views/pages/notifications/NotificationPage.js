import React, { useState, useEffect } from 'react';
import axios from 'axios';

const NotificationPage = () => {
    const [users, setUsers] = useState([]);
    const [selectedBulkEmails, setSelectedBulkEmails] = useState([]);
    const [bulkEmailSubject, setBulkEmailSubject] = useState('');
    const [bulkEmailMessage, setBulkEmailMessage] = useState('');
    const [bulkEmailStatus, setBulkEmailStatus] = useState('');
    const [bulkEmailLoading, setBulkEmailLoading] = useState(false);
    const [search, setSearch] = useState('');

    useEffect(() => {
        axios.post('http://localhost:3001/api/user/users')
            .then(res => {
                if (res.data.success && Array.isArray(res.data.data)) {
                    const formattedUsers = res.data.data.map(item => ({
                        ...item.user,
                        preference: item.preference || {},
                        relationProfile: item.relationProfile || [],
                    }));
                    setUsers(formattedUsers);
                } else {
                    setUsers([]);
                }
            })
            .catch(() => setUsers([]));
    }, []);

    const filteredUsers = users.filter(
        (user) => {
            const name = user.username || user.name || '';
            const phone = user.phone_number || '';
            const email = user.email || '';
            return (
                name.toLowerCase().includes(search.toLowerCase()) ||
                phone.toLowerCase().includes(search.toLowerCase()) ||
                email.toLowerCase().includes(search.toLowerCase())
            );
        }
    );

    const handleBulkEmailSend = async (e) => {
        e.preventDefault();
        setBulkEmailLoading(true);
        try {
            if (!selectedBulkEmails.length) {
                setBulkEmailStatus('No users selected to send email.');
                setBulkEmailLoading(false);
                return;
            }
            const res = await axios.post('http://localhost:3001/api/user/sendBulkEmailToUsers', {
                emails: selectedBulkEmails,
                subject: bulkEmailSubject,
                message: bulkEmailMessage,
            });
            if (res.data.success) {
                setBulkEmailStatus('Bulk email sent successfully!');
                setBulkEmailSubject('');
                setBulkEmailMessage('');
                setSelectedBulkEmails([]);
            } else {
                setBulkEmailStatus(res.data.message || 'Failed to send bulk email.');
            }
        } catch (err) {
            setBulkEmailStatus('Error sending bulk email: ' + (err?.message || err));
        }
        setBulkEmailLoading(false);
    };

    return (
        <div className="container mt-4">
            <h3>Send Bulk Notification Email</h3>
            <form onSubmit={handleBulkEmailSend} className="mb-2">
                <div className="mb-3">
                    <input
                        type="text"
                        placeholder="Search by name, phone, or email"
                        value={search}
                        onChange={e => setSearch(e.target.value)}
                        className="form-control"
                        style={{ maxWidth: 300 }}
                    />
                </div>
                <div style={{ maxHeight: 300, overflowY: 'auto', border: '1px solid #eee', borderRadius: 4, padding: 8, marginBottom: 12 }}>
                    {filteredUsers.map((user, idx) => (
                        <div key={user._id || idx} className="d-flex align-items-center mb-1">
                            <input
                                type="checkbox"
                                checked={selectedBulkEmails.includes(user.email)}
                                onChange={e => {
                                    setSelectedBulkEmails(prev =>
                                        e.target.checked
                                            ? [...prev, user.email]
                                            : prev.filter(email => email !== user.email)
                                    );
                                }}
                                style={{ marginRight: 8 }}
                            />
                            <span>{user.username || user.name || user.email} ({user.phone_number})</span>
                        </div>
                    ))}
                </div>
                <label>Subject</label>
                <input
                    type="text"
                    value={bulkEmailSubject}
                    onChange={e => setBulkEmailSubject(e.target.value)}
                    required
                    className="form-control mb-2"
                />
                <label>Message</label>
                <textarea
                    value={bulkEmailMessage}
                    onChange={e => setBulkEmailMessage(e.target.value)}
                    required
                    rows={4}
                    className="form-control mb-2"
                />
                <button type="submit" className="btn btn-primary" disabled={bulkEmailLoading}>Send Bulk Email</button>
                {bulkEmailStatus && (
                    <div className={`mt-2 alert alert-${bulkEmailStatus.includes('success') ? 'success' : 'danger'}`}>{bulkEmailStatus}</div>
                )}
            </form>
        </div>
    );
};

export default NotificationPage;
