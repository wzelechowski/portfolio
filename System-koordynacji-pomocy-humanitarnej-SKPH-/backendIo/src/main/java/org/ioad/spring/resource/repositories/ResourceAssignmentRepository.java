package org.ioad.spring.resource.repositories;
import org.ioad.spring.resource.models.ResourceAssignment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ResourceAssignmentRepository extends JpaRepository<ResourceAssignment, Long> {
    List<ResourceAssignment> findByResourceId(Long resourceId);
    List<ResourceAssignment> findByRequestId(Long requestId);
}

