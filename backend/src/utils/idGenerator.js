import { v4 as uuidv4 } from 'uuid';

function generateUniqueFileId() {
    return uuidv4();
}

module.exports = generateUniqueFileId;
