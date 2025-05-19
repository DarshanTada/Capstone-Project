class QueryPromise {
    constructor(db) {
        this.db = db;
    }
    queryPromise(SQL, params) {
        return new Promise((resolve, reject) => {
            this.db.query(SQL, [...params], (error, results) => {
                if (error)
                    return reject(error);
                resolve(results);
            });
        });
    }
    ;
}
module.exports = QueryPromise;
