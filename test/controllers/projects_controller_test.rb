require 'test_helper'

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @project = projects(:ureq)
    @user = users(:guille)
    @admin = users(:admin)
    sign_in(@user)
  end

  test 'should get index' do
    get projects_url
    assert_response :success
  end

  test 'should get new' do
    get new_project_url
    assert_response :success
  end

  test 'should create project' do
    assert_difference('Project.count' && 'Log.count') do
      post projects_url, params: {
        project: {
          client: @project.client, name: @project.name, status: @project.status
        }
      }
    end
    assert_equal(2, Project.last.user_projects.count)
    assert_equal(@user.id, Project.last.user_projects.first.user_id)
    assert_equal(@admin.id, Project.last.user_projects.last.user_id)
    assert_equal(true, Project.last.user_projects.first.owner)
    assert_equal(true, Project.last.user_projects.last.owner)
    assert_redirected_to projects_path
  end

  test 'should not create project' do
    assert_no_difference('Project.count') do
      post projects_url, params: { project: { name: '', status: @project.status } }
    end
  end

  test 'should get edit' do
    get edit_project_url(@project)
    assert_response :success
  end

  test 'should update project' do
    patch project_url(@project), params: { project: { client: 'Carlos Rossi' } }
    assert_equal(Project.find(@project.id).client, 'Carlos Rossi')
    assert_redirected_to projects_path
  end

  test 'should not update project' do
    patch project_url(@project), params: { project: { name: '' } }
    assert_not_equal(Project.find(@project.id).name, '')
  end

  test 'should not update project 2' do
    patch project_url(@project), params: { project: { status: 'test' } }
    assert_not_equal(Project.find(@project.id).status, 'test')
  end

  test 'should destroy project' do
    assert_no_difference('Project.count') do
      delete project_url(@project)
    end
    assert_equal(Project.find(@project.id).deleted, true)
    assert_redirected_to projects_url
  end
end
