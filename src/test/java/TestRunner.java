import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class TestRunner {
    @Test
    public void testParallel() {
        Results results = Runner.path("classpath:.").outputCucumberJson(true).tags("~@ignore").parallel(5);
        assertEquals(0, results.getFailCount(), results.getErrorMessages());
    }

    public static void main(String[] args) {
        TestRunner testRunner = new TestRunner();
        testRunner.testParallel();
    }
}