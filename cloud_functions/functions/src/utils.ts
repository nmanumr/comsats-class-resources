import { firestore } from "firebase-admin";

/**
 * Delete a collection from data firestore db
 * @param db firestore database instance
 * @param collectionPath collection path to remove
 * @param batchSize
 */
export function deleteCollection(db: firestore.Firestore, collectionPath: string, batchSize: number) {
    const collectionRef = db.collection(collectionPath);
    const query = collectionRef.orderBy('__name__').limit(batchSize);


    return new Promise((resolve, reject) => {
        return deleteQueryBatch(db, query, batchSize, resolve, reject);
    });
}

export async function deleteQueryBatch(
    db: firestore.Firestore,
    query: firestore.Query,
    batchSize: number,
    resolve: (value?: unknown) => void,
    reject: (reason?: any) => void
) {
    try {
        let numDeleted: number;
        const snapshot: firestore.QuerySnapshot = await query.get();

        if (snapshot.size === 0) {
            numDeleted = 0
        }
        
        else {
            // Delete documents in a batch
            const batch = db.batch();
            snapshot.docs.forEach((doc) => {
                batch.delete(doc.ref);
            });

            await batch.commit();
            numDeleted = snapshot.size;
        }

        if(numDeleted === 0){
            resolve();
            return;
        }

        // Recurse on the next process tick, to avoid
        // exploding the stack.
        process.nextTick(async () => {
            await deleteQueryBatch(db, query, batchSize, resolve, reject);
        });
    }
    catch (err) {
        reject(err);
    }
}