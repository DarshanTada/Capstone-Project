import React, { useState } from 'react';
import { CForm, CFormLabel, CFormInput, CFormTextarea, CButton, CAlert } from '@coreui/react';
import axios from 'axios';

const PromotionalEmailForm = ({ userEmail }) => {
    const [subject, setSubject] = useState('');
    const [message, setMessage] = useState('');
    const [status, setStatus] = useState('');
    const [loading, setLoading] = useState(false);

    const handleSend = async (e) => {
        e.preventDefault();
        setLoading(true);
        setStatus('');
        try {
            // Use the bulk email endpoint for individual emails
            const res = await axios.post('http://localhost:3001/api/user/sendBulkEmailToUsers', {
                emails: [userEmail],
                subject,
                message,
            });
            if (res.data.success) {
                setStatus('Email sent successfully!');
                setSubject('');
                setMessage('');
            } else {
                setStatus(res.data.message || 'Failed to send email.');
            }
        } catch (err) {
            setStatus('Error sending email: ' + (err?.message || err));
        }
        setLoading(false);
    };

    return (
        <CForm onSubmit={handleSend} className="mb-2">
            <CFormLabel>Email</CFormLabel>
            <CFormInput value={userEmail} disabled className="mb-2" />
            <CFormLabel>Subject</CFormLabel>
            <CFormInput value={subject} onChange={e => setSubject(e.target.value)} required className="mb-2" />
            <CFormLabel>Message</CFormLabel>
            <CFormTextarea value={message} onChange={e => setMessage(e.target.value)} required rows={4} className="mb-2" />
            <CButton type="submit" color="primary" disabled={loading}>Send Email</CButton>
            {status && <CAlert color={status.includes('success') ? 'success' : 'danger'} className="mt-2">{status}</CAlert>}
        </CForm>
    );
};

export default PromotionalEmailForm;
