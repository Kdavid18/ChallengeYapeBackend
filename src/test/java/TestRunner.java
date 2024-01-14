import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import net.masterthought.cucumber.Configuration;
import net.masterthought.cucumber.ReportBuilder;
import org.apache.commons.io.FileUtils;
import org.junit.Test;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;

public class TestRunner {
    @Test
    public void testRunner() throws IOException {
        String[] featureNames = {
                "auth/create-token",
                "booking/create-booking",
                "booking/delete-booking",
                "booking/get-booking",
                "booking/get-booking-id",
                "booking/partial-update-booking",
                "booking/update-booking",
                "ping/get-ping"
        };

        String path = "src/test/resources/features/";

        String[] featurePaths = Arrays.stream(featureNames)
                .map(featureName -> path + featureName + ".feature")
                .toArray(String[]::new);

        Results results = Runner.path(featurePaths)
                //.tags("@test")
                .outputCucumberJson(true)
                .parallel(1);
        generateReport(results.getReportDir());
    }

    public static void generateReport(String karateOutputPath) {
        Collection<File> jsonFiles = FileUtils.listFiles(new File(karateOutputPath), new String[]{"json"}, true);
        List<String> jsonPaths = new ArrayList<>(jsonFiles.size());
        jsonFiles.forEach(file -> jsonPaths.add(file.getAbsolutePath()));
        Configuration config = new Configuration(new File("target"), "yape");
        ReportBuilder reportBuilder = new ReportBuilder(jsonPaths, config);
        reportBuilder.generateReports();
    }


}

