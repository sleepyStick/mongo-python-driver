#!/bin/bash
PYMONGO=$(dirname "$(cd "$(dirname "$0")" || exit; pwd)")

### THINGS WE SHOULD DO:
# PYTHON-1873 - Test failure - TestCMAP --> WHY IS TICKET CLOSED?
rm $PYMONGO/test/connection_monitoring/wait-queue-fairness.json
# PYTHON-1894 - Specify effect of client-side errors on in-progress transactions
rm $PYMONGO/test/transactions/legacy/errors-client.json
# PYTHON-2943 - Socks5 Proxy Support
rm $PYMONGO/test/uri_options/proxy-options.json
# PYTHON-4918 - Add test that PoolClearedEvent is emitted before ConnectionCheckedInEvent/ConnectionCheckOutFailedEvent
rm $PYMONGO/test/discovery_and_monitoring/unified/pool-clear-application-error.json
rm $PYMONGO/test/discovery_and_monitoring/unified/pool-clear-checkout-error.json
rm $PYMONGO/test/discovery_and_monitoring/unified/pool-clear-min-pool-size-error.json
# PYTHON-4929 - Support QE with Client.bulkWrite
rm $PYMONGO/test/client-side-encryption/spec/unified/client-bulkWrite-qe.json

### THINGS WE WILL LIKELY NEVER DO
# Python doesn't implement DRIVERS-3064
rm $PYMONGO/test/collection_management/listCollections-rawdata.json
rm $PYMONGO/test/crud/unified/aggregate-rawdata.json
rm $PYMONGO/test/crud/unified/bulkWrite-deleteMany-rawdata.json
rm $PYMONGO/test/crud/unified/bulkWrite-deleteOne-rawdata.json
rm $PYMONGO/test/crud/unified/bulkWrite-replaceOne-rawdata.json
rm $PYMONGO/test/crud/unified/bulkWrite-updateMany-rawdata.json
rm $PYMONGO/test/crud/unified/bulkWrite-updateOne-rawdata.json
rm $PYMONGO/test/crud/unified/client-bulkWrite-delete-rawdata.json
rm $PYMONGO/test/crud/unified/client-bulkWrite-replaceOne-rawdata.json
rm $PYMONGO/test/crud/unified/client-bulkWrite-update-rawdata.json
rm $PYMONGO/test/crud/unified/count-rawdata.json
rm $PYMONGO/test/crud/unified/countDocuments-rawdata.json
rm $PYMONGO/test/crud/unified/db-aggregate-rawdata.json
rm $PYMONGO/test/crud/unified/deleteMany-rawdata.json
rm $PYMONGO/test/crud/unified/deleteOne-rawdata.json
rm $PYMONGO/test/crud/unified/distinct-rawdata.json
rm $PYMONGO/test/crud/unified/estimatedDocumentCount-rawdata.json
rm $PYMONGO/test/crud/unified/find-rawdata.json
rm $PYMONGO/test/crud/unified/findOneAndDelete-rawdata.json
rm $PYMONGO/test/crud/unified/findOneAndReplace-rawdata.json
rm $PYMONGO/test/crud/unified/findOneAndUpdate-rawdata.json
rm $PYMONGO/test/crud/unified/insertMany-rawdata.json
rm $PYMONGO/test/crud/unified/insertOne-rawdata.json
rm $PYMONGO/test/crud/unified/replaceOne-rawdata.json
rm $PYMONGO/test/crud/unified/updateMany-rawdata.json
rm $PYMONGO/test/crud/unified/updateOne-rawdata.json
rm $PYMONGO/test/index_management/index-rawdata.json

# PyMongo does not support modifyCollection
rm $PYMONGO/test/collection_management/modifyCollection-*.json

# PYTHON-5248 - pymongo no longer supports MongoDB 4.0
find /$PYMONGO/test -type f -name 'pre-42-*.json' -delete

# PYTHON-3359 - Remove Database and Collection level timeout override
#rm $PYMONGO/test/csot/override-collection-timeoutMS.json
#rm $PYMONGO/test/csot/override-database-timeoutMS.json -- i think this is done? the ticket is closed,,


# PYTHON-5517 - Avoid clearing the connection pool when the server connection rate limiter triggers
#rm $PYMONGO/test/discovery_and_monitoring/unified/backpressure-*.json -- should be merged to master now

echo "Done removing unimplemented tests"
