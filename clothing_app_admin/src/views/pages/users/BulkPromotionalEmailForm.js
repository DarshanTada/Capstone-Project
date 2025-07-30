import React, { useState } from 'react';
import { CForm, CFormLabel, CFormInput, CFormTextarea, CButton, CAlert } from '@coreui/react';
import axios from 'axios';

const BulkPromotionalEmailForm = () => {
    const [subject, setSubject] = useState('');
    const [message, setMessage] = useState('');
    const [status, setStatus] = useState('');
    const [loading, setLoading] = useState(false);
    const [userList, setUserList] = useState([]);
    const [selectedEmails, setSelectedEmails] = useState([]);

    // Fetch all users with role 'user' on mount
    React.useEffect(() => {
        axios.post('http://localhost:3001/api/user/users')
            .then(res => {
                if (res.data.success && Array.isArray(res.data.data)) {
                    const users = res.data.data
                        .filter(item => item.user?.role === 'user' && item.user?.email)
                        .map(item => ({
                            email: item.user.email,
                            username: item.preference?.username || '',
                            phone_number: item.user.phone_number || '',
                            _id: item.user._id
                        }));
                    setUserList(users);
                }
            })
            .catch(err => {
                setStatus('Error fetching users: ' + (err?.message || err));
            });
    }, []);

    const handleSend = async (e) => {
        e.preventDefault();
        setLoading(true);
        setStatus('');
        try {
            if (!selectedEmails.length) {
                setStatus('No users selected to send email.');
                setLoading(false);
                return;
            }
            const res = await axios.post('http://localhost:3001/api/user/sendBulkEmailToUsers', {
                emails: selectedEmails,
                subject,
                message,
            });
            if (res.data.success) {
                setStatus('Bulk email sent successfully!');
                setSubject('');
                setMessage('');
                setSelectedEmails([]);
            } else {
                setStatus(res.data.message || 'Failed to send bulk email.');
            }
        } catch (err) {
            setStatus('Error sending bulk email: ' + (err?.message || err));
        }
        setLoading(false);
    };

    return (
        <>
            <div className="mb-3">
                <CFormLabel>Select Users to Send Email</CFormLabel>
                <div style={{ maxHeight: 200, overflowY: 'auto', border: '1px solid #eee', borderRadius: 4, padding: 8 }}>
                    {userList.map(user => (
                        <div key={user._id} className="d-flex align-items-center mb-1">
                            <input
                                type="checkbox"
                                checked={selectedEmails.includes(user.email)}
                                onChange={e => {
                                    setSelectedEmails(prev =>
                                        e.target.checked
                                            ? [...prev, user.email]
                                            : prev.filter(email => email !== user.email)
                                    );
                                }}
                                style={{ marginRight: 8 }}
                            />
                            <span>{user.username || user.email} ({user.phone_number})</span>
                        </div>
                    ))}
                </div>
            </div>
            <CForm onSubmit={handleSend} className="mb-2">
                <CFormLabel>Subject</CFormLabel>
                <CFormInput value={subject} onChange={e => setSubject(e.target.value)} required className="mb-2" />
                <CFormLabel>Message</CFormLabel>
                <CFormTextarea value={message} onChange={e => setMessage(e.target.value)} required rows={4} className="mb-2" />
                <CButton type="submit" color="primary" disabled={loading}>Send Bulk Email</CButton>
                {status && <CAlert color={status.includes('success') ? 'success' : 'danger'} className="mt-2">{status}</CAlert>}
            </CForm>
        </>
    );
};

export default BulkPromotionalEmailForm;
