/*
Copyright (c) 2022 Younsung Hwang
SPDX-License-Identifier: AGPL-3.0-only
*/
package oss.fosslight.controller;

import org.apache.commons.io.FileUtils;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.core.io.DefaultResourceLoader;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.http.MediaType;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.web.servlet.MockMvc;
import oss.fosslight.common.Url;

import javax.transaction.Transactional;
import java.io.IOException;

import static org.hamcrest.core.IsEqual.equalTo;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.multipart;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@AutoConfigureMockMvc(addFilters = false)
@SpringBootTest
@Transactional
public class LicenseControllerTest {

    @Autowired
    private MockMvc mockMvc;

    private static final String USER_AGENT = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/44.0.2403.107 Safari/537.36";

    @BeforeAll
    private static void setEnvironment() {
        System.setProperty("--root.dir", getRootDir());
    }

    private static String getRootDir() {
        String os = System.getProperty("os.name").toLowerCase();
        if (os.contains("mac") || os.contains("darwin")) {
            return "/Users/Shared/fosslight";
        }
        if (os.contains("win")) {
            return "C:\\Users\\Public\\fosslight";
        }
        return "/usr/share/fosslight";
    }

    @Test
    @DisplayName("License bulk registration should be success When parameter is valid")
    public void licenseBulkRegistrationShouldBeSuccess() throws Exception {
        String bulkRegFileName = "license_bulk_test_v1.1.xls";
        MockMultipartFile bulkRegFile = new MockMultipartFile("myFile",
                bulkRegFileName,
                MediaType.MULTIPART_FORM_DATA_VALUE,
                bulkExcelByteArray(bulkRegFileName));

            mockMvc.perform(multipart(Url.LICENSE.CSV_FILE)
                            .file(bulkRegFile)
                            .param("tabNm", "BULK")
                            .header("user-agent", USER_AGENT))
                    .andExpect(status().isOk())
                    .andExpect(jsonPath("$.res", equalTo("true")))
                    .andExpect(jsonPath("$.value").exists())
                    .andExpect(jsonPath("$.value[0].license").exists())
                    .andExpect(jsonPath("$.value[0].status").exists());
    }

    private byte[] bulkExcelByteArray(String fileName) throws IOException {
        ResourceLoader resourceLoader = new DefaultResourceLoader();
        Resource bulkTestExcel = resourceLoader.getResource("oss.fosslight.controller/" + fileName);
        assertTrue(bulkTestExcel.exists(), "Bulk sample file does not exist.");
        return FileUtils.readFileToByteArray(bulkTestExcel.getFile());
    }
}