module ViewProject {
    requires javafx.controls;
    requires javafx.fxml;
    requires org.apache.commons.lang3;
    requires ModelProject;
    requires org.slf4j;
    requires java.sql;


    opens sudowoodo to javafx.fxml;
    exports sudowoodo;
}