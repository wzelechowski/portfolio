package project.plantify.AI.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.MediaType;
import org.springframework.http.client.MultipartBodyBuilder;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.reactive.function.BodyInserters;
import org.springframework.web.reactive.function.client.WebClient;
import project.plantify.AI.payloads.response.PhotoAnalysisResponse;
import reactor.core.publisher.Mono;

import java.util.List;
import java.util.Objects;

@Service
public class AIService {
    @Autowired
    @Qualifier("AI")
    private WebClient webClient;

    @Value("${plant.net.api.key}")
    private String API_KEY;

    public PhotoAnalysisResponse analyzePhoto(List<MultipartFile> images, String orgnas, String lang, String nbresults) {
        try {
            MultipartBodyBuilder builder = new MultipartBodyBuilder();

            for (MultipartFile image : images) {
                builder.part("images", image.getResource())
                    .filename(Objects.requireNonNull(image.getOriginalFilename()));
            }
            builder.part("organs", orgnas);

            PhotoAnalysisResponse response = webClient.post()
                    .uri(uriBuilder -> uriBuilder
                            .path("/all")
                            .queryParam("nb-results", nbresults)
                            .queryParam("lang", lang)
                            .queryParam("api-key", API_KEY)
                            .build())
                    .contentType(MediaType.MULTIPART_FORM_DATA)
                    .body(BodyInserters.fromMultipartData(builder.build()))
                    .retrieve()
                    .bodyToMono(PhotoAnalysisResponse.class)
                    .block();

            if (response != null) {
                return response;
            }
        } catch (RuntimeException e) {
            throw new RuntimeException("Błąd podczas wysyłania pliku do API", e);
        }
        return null;
    }
}
