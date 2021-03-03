package org.opengroup.osdu;

import org.apache.tinkerpop.gremlin.driver.Client;
import org.apache.tinkerpop.gremlin.driver.Cluster;
import org.apache.tinkerpop.gremlin.driver.ser.Serializers;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.ExecutionException;

public class Uploader {

    public static void main(String[] args) throws IOException, ExecutionException, InterruptedException {
        String dbHost = System.getProperty("GRAPH_DB_HOST");
        String password = System.getProperty("GRAPH_DB_PASSWORD");
        String intTesterUsername = System.getProperty("SERVICE_PRINCIPAL_ID");
        String noDataAccessTester = System.getProperty("NO_DATA_ACCESS_TESTER");
        String domain = System.getProperty("DOMAIN");

        Client client = createClient(dbHost, password);

        String[] commands = getGroovyCommands("/bootstrap-data.txt");
        for (String command : commands) {
            command = configureDomain(command, domain);
            submitCommand(client, command);
        }

        String bootStrapFile = "/users-for-integration-tests.txt";

        commands = getGroovyCommands(bootStrapFile);
        for (String command : commands) {
            command = configureDomain(command, domain);
            command = configureIntTester(command, intTesterUsername);
            command = configureNoDataAccessTester(command, noDataAccessTester);
            submitCommand(client, command);
        }

        System.exit(0);
    }

    private static String configureIntTester(String command, String intTester) {
        return command.replaceAll("INT_TESTER_USERNAME", intTester);
    }

    private static String configureNoDataAccessTester(String command, String noDataAccessTester) {
        return command.replaceAll("NO_DATA_ACCESS_TESTER", noDataAccessTester);
    }

    private static String configureDomain(String command, String domain) {
        return command.replaceAll("DOMAIN", domain);
    }

    private static Client createClient(String dbHost, String password) {
        Cluster cluster = Cluster.build(dbHost)
                .port(443)
                .credentials("/dbs/osdu-graph/colls/Entitlements", password)
                .enableSsl(true)
                .maxContentLength(65536)
                .serializer(Serializers.GRAPHSON_V2D0.toString())
                .create();
        return cluster.connect().alias("g");
    }

    private static String[] getGroovyCommands(String filename) throws IOException {
        String commands;
        try (InputStream inputStream = Uploader.class.getResourceAsStream(filename)) {
            if (inputStream == null) {
                throw new IOException();
            }
            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
            byte[] buffer = new byte[1024];
            int length;
            while ((length = inputStream.read(buffer)) != -1) {
                outputStream.write(buffer, 0, length);
            }
            commands = outputStream.toString(StandardCharsets.UTF_8.toString());
        }
        return commands.split(System.lineSeparator());
    }

    private static void submitCommand(Client client, String command) throws ExecutionException, InterruptedException {
        if ((Integer) client.submit(command).statusAttributes().get().get("x-ms-status-code") != 200) {
            throw new RuntimeException("Error during data upload");
        }
        System.out.println("Completed: " + command);
    }
}
