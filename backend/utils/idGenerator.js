const { v4: uuidv4 } = require('uuid');

function generateUniqueFileId() {
    return uuidv4();
}

module.exports = generateUniqueFileId;
