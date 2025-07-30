import React, { useState, useEffect } from 'react';
import { CCard, CCardBody, CCardHeader, CForm, CFormInput, CFormSelect, CButton, CAlert, CTable } from '@coreui/react';
import axios from 'axios';

const SubcategoryManagement = () => {
    const GENDER_OPTIONS = [
        { value: 'male', label: 'Male' },
        { value: 'female', label: 'Female' },
        { value: 'other', label: 'Other' },
    ];

    const BODYTYPE_FEMALE = [
        { value: 'Hourglass', label: 'Hourglass' },
        { value: 'Triangle', label: 'Triangle' },
        { value: 'Round', label: 'Round' },
        { value: 'Straight', label: 'Straight' },
        { value: 'Inverted Triangle', label: 'Inverted Triangle' },
    ];
    const BODYTYPE_MALE = [
        { value: 'Ectomorph', label: 'Ectomorph' },
        { value: 'Mesomorph', label: 'Mesomorph' },
        { value: 'Endomorph', label: 'Endomorph' },
    ];
    const BODYTYPE_OTHER = [
        { value: 'Hourglass', label: 'Hourglass' },
        { value: 'Triangle', label: 'Triangle' },
        { value: 'Round', label: 'Round' },
        { value: 'Straight', label: 'Straight' },
        { value: 'Inverted Triangle', label: 'Inverted Triangle' },
        { value: 'Ectomorph', label: 'Ectomorph' },
        { value: 'Mesomorph', label: 'Mesomorph' },
        { value: 'Endomorph', label: 'Endomorph' },
    ];

    const getBodyTypeOptions = () => {
        if (gender === 'female') return BODYTYPE_FEMALE;
        if (gender === 'male') return BODYTYPE_MALE;
        if (gender === 'other') return BODYTYPE_OTHER;
        return [];
    };
    const [categories, setCategories] = useState([]);
    const [subcategories, setSubcategories] = useState([]);
    const [selectedCategory, setSelectedCategory] = useState('');
    const [name, setName] = useState('');
    const [gender, setGender] = useState('male');
    const [bodyType, setBodyType] = useState('Hourglass');
    const [error, setError] = useState('');
    const [success, setSuccess] = useState('');

    useEffect(() => {
        fetchCategories();
    }, []);

    useEffect(() => {
        if (selectedCategory) fetchSubcategories(selectedCategory);
        else setSubcategories([]);
    }, [selectedCategory]);

    const fetchCategories = async () => {
        try {
            const res = await axios.get('http://localhost:3001/api/category/getCategory');
            setCategories(res.data.data || []);
        } catch {
            setCategories([]);
        }
    };

    const fetchSubcategories = async (catId) => {
        try {
            const res = await axios.get(`http://localhost:3001/api/subcategory/getByCategory/${catId}`);
            setSubcategories(res.data.data || []);
        } catch {
            setSubcategories([]);
        }
    };

    const handleAddSubcategory = async (e) => {
        e.preventDefault();
        setError('');
        setSuccess('');
        if (!selectedCategory) {
            setError('Select a category first');
            return;
        }
        if (!name.trim()) {
            setError('Subcategory name is required');
            return;
        }
        try {
            const res = await axios.post('http://localhost:3001/api/subcategory/createSubCategory', {
                name,
                category: selectedCategory,
                gender,
                body_type: bodyType,
            });
            if (res.data.success) {
                setSuccess('Subcategory added successfully!');
                setName('');
                setGender('male');
                setBodyType('Hourglass');
                fetchSubcategories(selectedCategory);
                setTimeout(() => setSuccess(''), 2000); // Hide success after 2 seconds
            } else {
                setError(res.data.message || 'Failed to add subcategory');
            }
        } catch {
            setError('Failed to add subcategory');
        }
    };

    const handleDeleteSubcategory = async (id) => {
        setError('');
        setSuccess('');
        try {
            const res = await axios.delete(`http://localhost:3001/api/subcategory/deleteSubCategory/${id}`);
            if (res.data.success) {
                setSuccess('Subcategory deleted successfully!');
                fetchSubcategories(selectedCategory);
                setTimeout(() => setSuccess(''), 2000); // Hide success after 2 seconds
            } else {
                setError(res.data.message || 'Failed to delete subcategory');
            }
        } catch {
            setError('Failed to delete subcategory');
        }
    };

    return (
        <CCard className="mb-4">
            <CCardHeader><strong>Subcategory Management</strong></CCardHeader>
            <CCardBody>
                {error && <CAlert color="danger">{error}</CAlert>}
                {success && <CAlert color="success">{success}</CAlert>}
                <CForm onSubmit={handleAddSubcategory} className="mb-4">
                    <CFormSelect
                        label="Select Category"
                        value={selectedCategory}
                        onChange={e => setSelectedCategory(e.target.value)}
                        required
                        className="mb-2"
                    >
                        <option value="">Select Category</option>
                        {categories.map(cat => (
                            <option key={cat._id} value={cat._id}>{cat.name}</option>
                        ))}
                    </CFormSelect>
                    <CFormInput
                        label="Subcategory Name"
                        value={name}
                        onChange={e => setName(e.target.value)}
                        required
                        className="mb-2"
                    />
                    <CFormSelect
                        label="Gender"
                        value={gender}
                        onChange={e => {
                            setGender(e.target.value);
                            // Reset body type to first option of new gender
                            const opts = e.target.value === 'female' ? BODYTYPE_FEMALE
                                : e.target.value === 'male' ? BODYTYPE_MALE
                                    : BODYTYPE_OTHER;
                            setBodyType(opts[0]?.value || '');
                        }}
                        required
                        className="mb-2"
                    >
                        {GENDER_OPTIONS.map(opt => (
                            <option key={opt.value} value={opt.value}>{opt.label}</option>
                        ))}
                    </CFormSelect>
                    <CFormSelect
                        label="Body Type"
                        value={bodyType}
                        onChange={e => setBodyType(e.target.value)}
                        required
                        className="mb-2"
                    >
                        {getBodyTypeOptions().map(opt => (
                            <option key={opt.value} value={opt.value}>{opt.label}</option>
                        ))}
                    </CFormSelect>
                    <CButton color="primary" type="submit">Add Subcategory</CButton>
                </CForm>
                <h5>All Subcategories</h5>
                <CTable bordered>
                    <thead>
                        <tr><th>Name</th><th>Actions</th></tr>
                    </thead>
                    <tbody>
                        {subcategories.map(sub => (
                            <tr key={sub._id}>
                                <td>{sub.name}</td>
                                <td>
                                    <CButton color="danger" size="sm" onClick={() => handleDeleteSubcategory(sub._id)}>Delete</CButton>
                                </td>
                            </tr>
                        ))}
                    </tbody>
                </CTable>
            </CCardBody>
        </CCard>
    );
};

export default SubcategoryManagement;
