package org.ioad.spring.task.repository;


import org.ioad.spring.request.models.Request;
import org.ioad.spring.task.model.Task;
import org.ioad.spring.task.model.TaskStatus;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository("TaskRepo")
public interface TaskRepo extends JpaRepository<Task, Long> {

    List<Task> findAll(Specification<Task> spec);

    Optional<Task> findByRequest(Request request);

    List<Task> findByVolunteers_User_UsernameAndStatus(String username, TaskStatus status);

    List<Task> findByVolunteers_User_Username(String username);
}
