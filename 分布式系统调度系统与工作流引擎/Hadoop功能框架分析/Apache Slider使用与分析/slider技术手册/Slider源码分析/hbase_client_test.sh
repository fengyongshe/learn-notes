#!/bin/sh

mkdir $HOME/tmp
cat <<EOF > $HOME/tmp/HBaseClientTest.java
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.hbase.HBaseConfiguration;
import org.apache.hadoop.hbase.TableName;
import org.apache.hadoop.hbase.client.*;

import java.io.IOException;

public class HBaseClientTest {
    public static void main (String [] args) throws IOException {
        Configuration conf = HBaseConfiguration.create();
        Connection conn = ConnectionFactory.createConnection(conf);

        Admin admin = conn.getAdmin();
        TableName[] tableNames = admin.listTableNames();
        for (TableName tableName : tableNames) {
            System.out.println (tableName.getNameWithNamespaceInclAsString());
        }
        admin.close();
        conn.close();
    }
}
EOF

export HBASE_CLIENT="/home/yz_newland/yz_nl_hbase"

cd $HOME/tmp
javac -cp `$HBASE_CLIENT/bin/hbase classpath` HBaseClientTest.java
java -cp `$HBASE_CLIENT/bin/hbase classpath`:. HBaseClientTest
